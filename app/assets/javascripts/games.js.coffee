window.modalWasShown = false

Game = {
  Actions: {}
  Helpers: {}
  Data: {
    Board: {}
    Player: {}
    Round: {}
  }
}

Actions = Game.Actions
Data = Game.Data
Helpers = Game.Helpers

Actions.refreshGame = () ->
  if /\/games\/[0-9]+$/.test(window.location.pathname)
    $.ajax
      url: document.URL + '.json',
      success: (board) ->
        Data.Board = board
        # Data.Round = board.game.round 
        console.info("Game data recieved.")
        if not board.finished
          Actions.setBlackCard()
          Actions.setUserPoints(board.player.score)
          Actions.setCzarInfo(board.czar.self, board.czar.email)
          Actions.setGameHand(board.player, board.czar.self, board.submissions)

          if board.czar.self
            if $('#player-hand h2').length is 0
              $('#player-hand').empty() unless $('#player-hand .white-card').length is 0
              Actions.showPlayersWaiting(board.players)
            else
              Actions.updatePlayersWaiting(board.players)
          else
            Actions.updatePlayerHand()
            Actions.showLastGameWinner(board.winner) 

          if board.player.submissions_left == 0 and not board.czar.self
            Actions.showLastRoundInfo(board.game_hand, board.winner)
        else
          console.info("The Game has finished.")
          Actions.endGame()

Actions.setGameHand = (player, czar, hand) ->
  $.ajax
    url: document.URL + "/submissions"
    success: (sub_data) ->
      if czar
        Helpers.generateCards(hand, 'white', 'game', czar)

        # $('#player-hand').empty()
        $('#game-content #game-hand .white-card.effect2').click ->
          if confirm("Are you sure you want to choose this card?")
            cardId = $(this).attr('card-id')
            $.ajax
              url: document.URL + "/submissions/submit?id=" + cardId
              type: 'POST'
              success: (select_data, select_textStatus, select_jqXHR) ->
                $('#game-content #game-hand').empty()
                Actions.refreshGame()
              error: ->
                console.error("There seems to be an issue connecting to the server.\nPlease try refreshing the page.")
      else
        $('#game-hand').empty()
        Helpers.generateCards(hand, 'white', 'game', czar) if player.submissions_left == 0
    error: ->
      console.error('Could not get submissions for game.')

Actions.setBlackCard = () ->
  bc = Data.Board.black_card
  cardDiv = $('#black-card')[0]
  cardDiv.textContent = bc.content + '\nPick ' + bc.num_blanks
  cardDiv.setAttribute('class', 'black-card effect2')

  $('#game-content')[0].insertBefore(cardDiv, document.getElementById('game-content').firstChild)

Helpers.generateCard = (card, color, hand, czar) ->
  cardDiv = document.createElement('div')
  cardDiv.textContent = card.content
  cardDiv.setAttribute('class', color + '-card effect2')
  cardDiv.setAttribute('card-id', card['id'])

  if hand == 'game' && czar
    dv = document.createElement('div')
    dv.textContent = card['user_id']
    cardDiv.appendChild(dv)

  document.getElementById(hand + '-hand').appendChild(cardDiv)

Helpers.generateCards = (cardArr, color, hand, czar) ->
  $('#' + hand + '-hand').empty()
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
  Actions.updatePlayerWaiting players, player for player in $('#player-hand ul.list-group')[0].children

Actions.updatePlayerWaiting = (players, player) ->
  for current in players
    debugger
    return unless players[x].email == player.textContent

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
      hand = playerHand[0]
      console.info("Generating player hand cards...")
      Helpers.generateCards(hand.white_cards, 'white', 'player', false)
      if hand.submissions_left > 0
        $('#player-hand .white-card.effect2').click ->
          if confirm('Are you sure you want to choose this card?')
            cardId = $(this).attr('card-id')
            $.ajax
              type: 'POST'
              url: document.URL + "/submissions?card_id=" + cardId
              success: ->
                console.info('Card was successfully posted')
                $('.white-card[card-id=' + cardId + ']').remove();
              error: ->
                console.error("Could not send card to server")
    error: ->
      console.error("Could not get hand data.")

Actions.refreshGame()
# setInterval(Actions.refreshGame, 1600)
