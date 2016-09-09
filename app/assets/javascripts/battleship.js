$(document).ready(function() {

  $(".cell").each(function() {
    var cell = $(this);

    var row = cell.data("row");
    var col = cell.data("column");

    $.ajax({
      url: window.location.pathname,
      type: "GET",
      dataType: "json",
      data: { row : row, col : col},
      success: function(data) {
        var status = data.status;
        var row = data.row;
        var col = data.column;

        if (status == "hit") {
          cell.css("background", "red");
        } else if (status == "miss") {
          cell.css("background", "grey");
        }
      },
      error: function() {
        alert("Ajax Error!!!");
      }

    });

  });

});
