window.modalWasShown = false

Actions = {}
Helpers = {}
Board = {}
Intervals = {}

Actions.refreshGame = () ->
  $.ajax
    url: document.URL + '.json',
    success: (board) ->
      console.info("Game data recieved.")
      Actions.resetBoard()

      Board = board

      if not board.finished
        Actions.setBlackCard()
        Actions.setUserPoints(board.player.score)
        Actions.setCzarInfo(board.czar.self, board.czar.email)

        if board.czar.self
          Actions.showPlayersWaiting(board.players)
        else
          Actions.updatePlayerHand()
          Actions.showLastGameWinner(board.winner)

      else
        console.info("The Game has finished.")
        Actions.endGame()

Actions.resetBoard = () ->
  $('#player-hand').empty()
  $('#game-hand').empty()
  console.info('Game board reset.')

Actions.setGameHand = () ->
  $.ajax
    url: document.URL + "/submissions"
    success: (submission_data) ->
      submissions = submission_data.submissions
      czar = submission_data.czar
      currentNumSubmissions = $('#game-hand')[0].children.length
      console.info("Submissions for game recived.")
      if Board.game.round == submission_data.round 
        if czar
          Helpers.generateCards(submissions.slice(currentNumSubmissions, submissions.length), 'white', 'game', czar)
          Actions.updatePlayersWaiting(submission_data.players)

          $('#game-content #game-hand .white-card.effect2').slice(currentNumSubmissions, submissions.length).click ->
            if confirm("Are you sure you want to choose this card?")
              cardId = $(this).attr('card-id')
              $.ajax
                url: document.URL + "/submissions/submit?id=" + cardId
                type: 'POST'
                success: () ->
                  Actions.refreshGame()
                error: () ->
                  console.error("There seems to be an issue connecting to the server.\nPlease try refreshing the page.")
        else if Board.player and (Board.player.submissions_left == 0)
          Helpers.generateCards(submissions.slice(currentNumSubmissions, submissions.length), 'white', 'game', czar)
      else if Board.game.round
        Actions.refreshGame()
    error: () ->
      console.error('Could not get submissions for game.')

Actions.setBlackCard = () ->
  bc = Board.black_card
  cardDiv = $('#black-card')[0]
  cardDiv.textContent = bc.content + '\nPick ' + bc.num_blanks
  cardDiv.setAttribute('class', 'black-card effect2')

  $('#game-content')[0].insertBefore(cardDiv, document.getElementById('game-content').firstChild)

Helpers.generateCard = (card, color, hand, czar) ->
  cardDiv = document.createElement('div')
  cardDiv.textContent = card.content
  cardDiv.setAttribute('class', color + '-card effect2')
  cardDiv.setAttribute('card-id', card['id'])

  # if hand == 'game' && czar
  #   dv = document.createElement('div')
  #   dv.textContent = card['user_id']
  #   cardDiv.appendChild(dv)

  document.getElementById(hand + '-hand').appendChild(cardDiv)

Helpers.generateCards = (cardArr, color, hand, czar) ->
  Helpers.generateCard card, color, hand, czar for card in cardArr

Actions.setUserPoints = (value) ->
  $('#status-player-points')[0].textContent = value

Actions.setCzarInfo = (self, name) ->
  $('#status-czar')[0].textContent = if self then "YOU ARE THE CZAR" else name

Actions.endGame = () ->
  $('#game-content').empty()
  $('#player-hand').empty()

  endText = document.createElement('h1')
  endText.textContent = "The Game Has Ended"
  $('#game-content')[0].appendChild(endText)

Actions.showPlayersWaiting = (players) ->
  heading = document.createElement('h2')
  heading.textContent = 'Players Left To Submit:'
  $('#player-hand')[0].appendChild(heading)
  list = document.createElement('ul')
  list.setAttribute('class', 'list-group')
  Actions.showPlayerWaiting list, player for player in players
  $('#player-hand')[0].appendChild(list)

Actions.updatePlayersWaiting = (players) ->
  console.info("Update Players Waiting")
  list = $('#player-hand ul.list-group')[0]
  if list 
    Actions.updatePlayerWaiting players, player for player in list.children

Actions.updatePlayerWaiting = (players, player) ->
  for current in players
    return unless current.email == player.textContent

  player.remove()

Actions.showPlayerWaiting = (list, player) ->
  if player.submissions_left > 0
    li = document.createElement('li')
    li.textContent = player.email
    li.setAttribute('class', 'list-group-item')
    list.appendChild(li)

Actions.showLastGameWinner = (winner) ->
  $('#status-winner')[0].textContent = if winner.email then winner.email else 'N/A'

Actions.showLastRoundInfo = (cards, winner) ->
  jQuery.noConflict()
  Helpers.generateCards(cards, 'white', 'modal', false)
  if not window.modalWasShown
    $('#myModal').modal()
  window.modalWasShown = true;

Actions.updatePlayerHand = () ->
  $.ajax
    url: document.URL + '/hand'
    success: (playerHand) ->
      console.info("Generating player hand cards...")
      currentNumCard = $('#player-hand')[0].children.length
      cards = playerHand.white_cards
      Helpers.generateCards(cards.slice(currentNumCard, cards.length), 'white', 'player', false)
      if playerHand.submissions_left > 0
        $('#player-hand .white-card.effect2').click ->
          if confirm('Are you sure you want to choose this card?')
            cardId = $(this).attr('card-id')
            $.ajax
              type: 'POST'
              url: document.URL + "/submissions?card_id=" + cardId
              success: ->
                console.info('Card was successfully submitted')
                $('.white-card[card-id=' + cardId + ']').remove();
                playerHand.submissions_left -= 1

                if playerHand.submissions_left == 0
                  Actions.showLastRoundInfo(Board.submissions, Board.winner) 
              error: ->
                console.error("Could not send card to server")
    error: ->
      console.error("Could not get hand data.")

Helpers.getGameHand = () ->
  $('#game-hand')

if /\/games\/[0-9]+$/.test(window.location.pathname)
  Actions.refreshGame()
  Intervals.gameHandRefresh = setInterval(Actions.setGameHand, 1500)
