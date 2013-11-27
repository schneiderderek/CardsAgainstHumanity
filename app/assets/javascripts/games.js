window.modalWasShown = false;
refreshGame();
setInterval(refreshGame, 1600);

function refreshGame() {
  if (/\/games\/[0-9]+$/.test(window.location.pathname)) {
    $.ajax({
      url: document.URL + '.json',
      success: function(game_data, game_textStatus, game_jqXHR) {
        if (!game_data.game.finished) {
          setBlackCard(game_data.black_card);
          setUserPoints(game_data.player.score);
          setCzarInfo(game_data.czar.self, game_data.czar.email);
          setGameHand(game_data.player, game_data.czar.self, game_data.game_hand)

          if (game_data.czar.self) {
            showPlayersWaiting(game_data.players);
          } else {
            setPlayerHand(game_data.player, game_data.player_hand, game_data.game_hand, game_data.winner);
            showLastGameWinner(game_data.winner);
          }

          if (game_data.player.submissions_left == 0 && !game_data.czar.self) {
            showLastRoundInfo(game_data.game_hand, game_data.winner); 
          }

        } else {
          console.info("The Game has finished.");
          endGame();
        }
      }
    });
  }
}

function setGameHand(player, czar, hand) {
  if (czar) {
    generateCards(hand, 'white', 'game', czar);

    $('#player-hand').empty();
    $('#game-content #game-hand .white-card.effect2').click(function() {

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
  } else if (player.submissions_left == 0) {
    $('#game-hand').empty();
    generateCards(hand, 'white', 'game', czar);
  } else {
    $('#game-hand').empty();
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

function setCzarInfo(self, name) {
  $(document).ready(function() {
    $('#status-czar')[0].textContent = self ? "YOU ARE THE CZAR" : name;
  });
}

function endGame() {
  $(document).ready(function() {
    $('#game-content').empty();
    $('#player-hand').empty();

    var endText = document.createElement('h1');
    endText.textContent = "The Game Has Ended";
    $('#game-content')[0].appendChild(endText);
  });
}

function showPlayersWaiting(players) {
  $(document).ready(function() {
    var heading = document.createElement('h2');
    heading.textContent = "Players Left To Submit:";
    $('#player-hand')[0].appendChild(heading);

    var list = document.createElement('ul');
    list.setAttribute('class', 'list-group');

    for(var i = 0; i < players.length; i++) {
      if (players[i].submissions_left > 0) {
        var li = document.createElement('li');
        li.textContent = players[i].email;
        li.setAttribute('class', 'list-group-item');
        list.appendChild(li);
      }
    }

    $('#player-hand')[0].appendChild(list);
  });
}

function showLastGameWinner(winner) {
  $(document).ready(function() {
    $('#status-winner')[0].textContent = winner.email ? winner.email : "N/A";
  });
}

function showLastRoundInfo(cards, winner) {
  $(document).ready(function() {
    jQuery.noConflict();
    generateCards(cards, 'white', 'modal', false);
    if (!window.modalWasShown) {
      $('#myModal').modal();
    }
    window.modalWasShown = true;
  });
}

