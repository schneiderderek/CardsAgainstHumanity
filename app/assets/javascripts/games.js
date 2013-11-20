czar = false;

// Fill in the users hand
if (/\/games\/[0-9]+/.test(window.location.pathname)) {
  getBlackCard();
  refreshGameHand();
}

function refreshPlayerHand() {
  $.ajax({
    url: document.URL + "/users/" + $.cookie("user_id") + "/hand.json",
    success: function(hand_data, hand_textStatus, hand_jqXHR) {
      console.info(czar)
      if (!czar) {
        $(document).ready(function(){
          $('#player-hand').empty();

          for (var i = 0; i < hand_data.length; i++) {
            generateCard(hand_data[i], 'white', 'player');
          }

          $('#player-hand .white-card').click(function() {
            if (confirm("Are you sure you want to choose this card?")) {
              var cardId =  $(this).attr('card-id');
              $.ajax({
                url: document.URL + "/hand.json?card_id=" + cardId,
                type: 'POST',
                success: function(select_data, select_textStatus, select_jqXHR) {
                  $('.white-card[card-id=' + cardId + ']').remove();
                  refreshGameHand();
                },
                error: function() {
                  alert("There seems to be an issue connecting to the server.\nPlease try refreshing the page.");
                }
              });
            }
          });
        });
      }
    }
  });
}

// Get the Black card for the game
function getBlackCard(){
  $.ajax({
    url: document.URL + "/black_card.json",
    success: function(card_data, card_textStatus, card_jqXHR) {
      $(document).ready(function(){
        var card_div = document.createElement('div');
        card_div.textContent = card_data['content'] + '\nPick ' + card_data['num_blanks'];
        card_div.setAttribute('class', 'black-card');

        document.getElementById('game-content').insertBefore(card_div, document.getElementById('game-content').firstChild);
      });
    }
  });
}

function generateCard(card, color, hand) {
  var card_div = document.createElement("div");
  card_div.textContent = card['content'];
  card_div.setAttribute("class", color + '-card');
  card_div.setAttribute("card-id", card['id']);

  document.getElementById(hand + "-hand").appendChild(card_div);
}

function refreshGameHand() {
  $('#game-hand').empty();

  $.ajax({
    url: document.URL + "/white_cards.json",
    success: function(game_hand_data, game_hand_textStatus, game_hand_jqXHR) {
      $(document).ready(function() {
        for(var i = 0; i < game_hand_data['white_cards'].length; i++) {
          generateCard(game_hand_data['white_cards'][i], 'white', 'game');
        }
      });

      if (game_hand_data['czar']) {
        $('#player-hand').empty();

        $(document).ready(function() {
          var playerHand = document.getElementById('player-hand');
          playerHand.textContent = "You are the card czar";
          playerHand.setAttribute('class', 'czar');

          $('#game-content #game-hand .white-card').click(function() {
            if (confirm("Are you sure you want to choose this card?")) {
              var cardId =  $(this).attr('card-id');
              $.ajax({
                url: document.URL + "/hand.json?card_id=" + cardId,
                type: 'POST',
                success: function(select_data, select_textStatus, select_jqXHR) {
                  $('#game-content #game-hand').empty();
                },
                error: function() {
                  alert("There seems to be an issue connecting to the server.\nPlease try refreshing the page.");
                }
              });
            }
          });
        });
      } else {
        refreshPlayerHand();
      }
    }
  });
}
