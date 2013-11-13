$.ajax({
  url: "http://localhost:3000/games/1.json",
  success: function(data, textStatues, jqXHR) {
    console.info(data);
  }
});
