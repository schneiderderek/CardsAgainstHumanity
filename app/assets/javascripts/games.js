$.ajax({
  url: document.URL + ".json",
  success: function(game_data, game_textStatus, game_jqXHR) {
    $.ajax({
      url: document.URL + "/users/" + $.cookie("user_id") + "/hands.json",
      success: function(hands_data, hands_textStatus, hands_jqXHR) {
        console.warn(document.URL + "/users/" + $.cookie("user_id") + "/hands/" + hands_data[0]["id"] + ".json")
        $.ajax({
          url: document.URL + "/users/" + $.cookie("user_id") + "/hands/" + hands_data[0]["id"] + ".json",
          success: function(hand_data, hand_textStatus, hand_jqXHR) {
            for (var i = 0; i < hand_data.length; i++) {
              generateCard(hand_data[i]['content']);
            }
          }
        });        
      }
    });
  }
});


function generateCard(text) {
  var card_div = document.createElement("div");
  var inner_text_el = document.createElement("p");
  inner_text_el.innerText = text
  card_div.setAttribute("class", "white-card");
  card_div.appendChild(inner_text_el);

  document.getElementById("player-hand").appendChild(card_div);
}
