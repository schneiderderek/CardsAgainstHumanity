window.App.Actions.updatePlayerHand = () ->
  $.ajax
    url: document.URL + '/hand'
    success: (playerHand) ->
      hand = playerHand[0]
      console.info("Generating player hand cards...")
      generateCards(hand.white_cards, 'white', 'player', false)
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
