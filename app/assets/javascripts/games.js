// Fill in the users hand
refreshHand();

function refreshHand() {
  $.ajax({
    url: document.URL + "/users/" + $.cookie("user_id") + "/hand.json",
    success: function(hand_data, hand_textStatus, hand_jqXHR) {
      $(document).ready(function(){
        $('#player-hand').empty();

        for (var i = 0; i < hand_data.length; i++) {
          generateCard(hand_data[i], 'white', 'player');
        }

        $('.white-card').click(function() {
          if (confirm("Are you sure you want to choose this card?")) {
            $.ajax({
              url: document.URL + "/hand.json?card_id=" + $(this).attr('card-id'),
              type: 'POST',
              success: function(select_data, select_textStatus, select_jqXHR) {
                refreshHand();
              },
              error: function() {
                console.error("REQUEST FAILED")
              }
            });
          }
        });
      });
    }
  });
}

// Get the Black card for the game
$.ajax({
  url: document.URL + "/black_card.json",
  success: function(card_data, card_textStatus, card_jqXHR) {
    $(document).ready(function(){
      var card_div = document.createElement('div');
      card_div.innerText = card_data['content'] + '\n\nPick ' + card_data['num_blanks'];
      card_div.setAttribute('class', 'black-card');

      document.getElementById('game-content').insertBefore(card_div, document.getElementById('game-content').firstChild);
    });
  }
});

function generateCard(card, color, hand) {
  var card_div = document.createElement("div");
  card_div.innerText = card['content'];
  card_div.setAttribute("class", color + '-card');
  card_div.setAttribute("card-id", card['id']);

  document.getElementById(hand + "-hand").appendChild(card_div);
}
