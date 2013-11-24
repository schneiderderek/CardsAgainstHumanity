var czar = false;
var game;
var picks;

refreshGame();
setInterval(refreshGame, 1000);

function refreshGame() {
  if (/\/games\/[0-9]+/.test(window.location.pathname)) {
    $.ajax({
      url: document.URL + '.json',
      success: function(game_data, game_textStatus, game_jqXHR) {
        console.warn('Game updated.');
        window.game = game_data;
        window.picks = game_data.black_card.num_blanks;

        setBlackCard();
        setHand(game_data.czar, game_data.game_hand);
        setHand(game_data.czar, game_data.player_hand);
      }
    });
  }
}

function setHand(czar, cards) {
  if (!czar) {
    generateCards(cards, 'white', 'player', czar);

    $('#player-hand .white-card.effect2').click(function() {
      if (confirm('Are you sure you want to choose this card?')) {
        var cardId =  $(this).attr('card-id');
        $.ajax({
          url: document.URL + "/hand.json?card_id=" + cardId,
          type: 'POST',
          success: function(select_data, select_textStatus, select_jqXHR) {
            $('.white-card[card-id=' + cardId + ']').remove();
            window.pick--;
          },
          error: function() {
            alert("There seems to be an issue connecting to the server.\nPlease try refreshing the page.");
          }
        });
      }
    });
  } else {
    generateCards(cards, 'white', 'game', czar)

    $('#player-hand').empty();
    var playerHand = document.getElementById('player-hand');
    var czar_heading = document.createElement('h1');
    czar_heading.textContent = "You are the card czar";
    czar_heading.setAttribute('class', 'czar');
    playerHand.appendChild(czar_heading);

    $('#game-content #game-hand .white-card').click(function() {
      if (confirm("Are you sure you want to choose this card?")) {
        var cardId = $(this).attr('card-id');
        $.ajax({
          url: document.URL + "/hand.json?card_id=" + cardId,
          type: 'POST',
          success: function(select_data, select_textStatus, select_jqXHR) {
            $('#game-content #game-hand').empty();
            refreshGame();
          },
          error: function() {
            alert("There seems to be an issue connecting to the server.\nPlease try refreshing the page.");
          }
        });
      }
    });
  }
}

function setBlackCard() {
  $(document).ready(function() {
    var card_div = document.getElementById('black-card');
    card_div.textContent = window.game.black_card.content + '\nPick ' + window.game.black_card.num_blanks;
    card_div.setAttribute('class', 'black-card effect2');

    document.getElementById('game-content').insertBefore(card_div, document.getElementById('game-content').firstChild);
  });
}

function generateCard(card, color, hand, czar) {
  var card_div = document.createElement('div');
  card_div.textContent = card.content;
  card_div.setAttribute('class', color + '-card effect2');
  card_div.setAttribute('card-id', card['id']);

  if (hand == 'game' && czar) {
    var dv = document.createElement('div');
    dv.textContent = card['user_id'];
    card_div.appendChild(dv);
  }

  document.getElementById(hand + '-hand').appendChild(card_div);
}

function generateCards(cardArr, color, hand, czar) {
  $(document).ready(function() {
    $('#' + hand + '-hand').empty();
    for(var i = 0; i < cardArr.length; i++) {
      generateCard(cardArr[i], color, hand, czar);
    }
  });
}