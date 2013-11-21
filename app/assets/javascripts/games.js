var czar = false;
var game;
var picks;

// Fill in the users hand
if (/\/games\/[0-9]+/.test(window.location.pathname)) {

  $.ajax({
    url: document.URL + '.json',
    success: function(game_data, game_textStatus, game_jqXHR) {
      window.game = game_data;
      window.picks = game_data.black_card.num_blanks;

      setBlackCard();
      refreshGameHand();
    }
  });
}

function refreshPlayerHand() {
  $.ajax({
    url: document.URL + "/users/" + $.cookie("user_id") + "/hand.json",
    success: function(hand_data, hand_textStatus, hand_jqXHR) {
      if (!czar) {
        $(document).ready(function(){
          $('#player-hand').empty();

          for (var i = 0; i < hand_data.length; i++) {
            generateCard(hand_data[i], 'white', 'player');
          }

          $('#player-hand .white-card.effect2').click(function() {
            console.info("Added event hanler for: " + this);
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
                  alert("There seems to be an issue connecting to the server dumbass.\nPlease try refreshing the page.");
                }
              });
            }
          });
        });
      }
    }
  });
}

function setBlackCard(){
  $(document).ready(function(){
    var card_div = document.createElement('div');
    card_div.textContent = window.game.black_card.content + '\nPick ' + window.game.black_card.num_blanks;
    card_div.setAttribute('class', 'black-card effect2');

    document.getElementById('game-content').insertBefore(card_div, document.getElementById('game-content').firstChild);
  });
}

function generateCard(card, color, hand, czar) {
  var card_div = document.createElement("div");
  card_div.textContent = card['content'];
  card_div.setAttribute("class", color + '-card effect2');
  card_div.setAttribute("card-id", card['id']);

  if (hand == 'game' && czar) {
    var dv = document.createElement('div');
    dv.textContent = card['user_id'];
    card_div.appendChild(dv);
  }

  document.getElementById(hand + "-hand").appendChild(card_div);
}

function refreshGameHand(cards) {
  $('#game-hand').empty();

  for(var i = 0; i < window.game.white_cards.length; i++) {
    generateCard(window.game.white_cards[i], 'white', 'game', window.game.czar);
  }

  if (window.game.czar) {
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
