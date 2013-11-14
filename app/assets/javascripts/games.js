$.ajax({
  url: document.URL + ".json",
  success: function(game_data, game_textStatus, game_jqXHR) {
    // Fill in user's hand
    $.ajax({
      url: document.URL + "/users/" + $.cookie("user_id") + "/hands.json",
      success: function(hands_data, hands_textStatus, hands_jqXHR) {
        console.warn(document.URL + "/users/" + $.cookie("user_id") + "/hands/" + hands_data[0]["id"] + ".json")
        $.ajax({
          url: document.URL + "/users/" + $.cookie("user_id") + "/hands/" + hands_data[0]["id"] + ".json",
          success: function(hand_data, hand_textStatus, hand_jqXHR) {
            for (var i = 0; i < hand_data.length; i++) {
              generateCard(hand_data[i]['content'], 'white', 'player');
            }
          }
        });        
      }
    });

    // Get the Black card for the game
    $.ajax({
      url: document.URL + "/black_card.json",
      success: function(card_data, card_textStatus, card_jqXHR) {
        var card_div = document.createElement('div');
        card_div.innerText = card_data['content']
        card_div.setAttribute('class', 'black-card');

        document.getElementById('game-content').insertBefore(card_div, document.getElementById('game-content').firstChild)
      }
    });

  }
});


function generateCard(text, color, hand) {
  var card_div = document.createElement("div");
  card_div.innerText = text
  card_div.setAttribute("class", color + '-card');

  document.getElementById(hand + "-hand").appendChild(card_div);
}
