refreshGame();
setInterval(refreshGame, 1000);

function refreshGame() {
  if (/\/games\/[0-9]+$/.test(window.location.pathname)) {
    $.ajax({
      url: document.URL + '.json',
      success: function(game_data, game_textStatus, game_jqXHR) {
        console.info('Game updated.');

        setBlackCard(game_data.black_card);
        setUserPoints(game_data.player.score);
        setCzarInfo(game_data.czar.email);
        setPlayerHand(game_data.player, game_data.player_hand);
        setGameHand(game_data.czar.self, game_data.game_hand)
      }
    });
  }
}

function setGameHand(czar, hand) {
  if (czar) {
    generateCards(hand, 'white', 'game', czar);

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

function setPlayerHand(player, hand) {
  generateCards(hand, 'white', 'player', false);

  if (player.submissions_left > 0) {
    $('#player-hand .white-card.effect2').click(function() {
      if (confirm('Are you sure you want to choose this card?')) {
        var cardId =  $(this).attr('card-id');
        $.ajax({
          url: document.URL + "/hand.json?card_id=" + cardId,
          type: 'POST',
          success: function(select_data, select_textStatus, select_jqXHR) {
            $('.white-card[card-id=' + cardId + ']').remove();
          },
          error: function() {
            alert("There seems to be an issue connecting to the server.\nPlease try refreshing the page.");
          }
        });
      }
    });
  }
}

function setBlackCard(black_card) {
  $(document).ready(function() {
    var card_div = $('#black-card')[0];
    card_div.textContent = black_card.content + '\nPick ' + black_card.num_blanks;
    card_div.setAttribute('class', 'black-card effect2');

    $('#game-content')[0].insertBefore(card_div, document.getElementById('game-content').firstChild);
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

function setUserPoints(value) {
  $(document).ready(function() {
    $('#status-player-points')[0].textContent = value;
  });
}

function setCzarInfo(name) {
  $(document).ready(function() {
    $('#status-czar')[0].textContent = name;
  });
}