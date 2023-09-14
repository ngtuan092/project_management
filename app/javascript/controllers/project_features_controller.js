export const addFieldProjectFeature = () => {
  function calculateTotal() {
    var total = 0;

    var nestedField = document.querySelectorAll(".nested-fields");
    nestedField.forEach((element) => {
      var effortSavedInputs =
        element.getElementsByClassName("effort_saved-input");
      var repeatTimeInputs =
        element.getElementsByClassName("repeat_time-input");
      var effortSaved = parseFloat(effortSavedInputs.item(0).value);
      var repeatTime =  parseFloat(repeatTimeInputs.item(0).value);

      var repeatUnitSelects =
        element.getElementsByClassName("repeat_unit-select");
      var repeatUnit = repeatUnitSelects.item(0).value;

      if (!isNaN(effortSaved) && !isNaN(repeatTime)) {
        effortSaved *= repeatTime
        switch (repeatUnit) {
          case "day":
            total += effortSaved * 22;
            break;
          case "week":
            total += effortSaved * 4;
            break;
          case "month":
            total += effortSaved;
            break;
          case "quarter":
            total += effortSaved / 4;
            break;
          case "year":
            total += effortSaved / 12;
            break;
          case "half_a_year":
            total += effortSaved / 6;
            break;
          default:
            break;
        }
      }
    });

    var effortSavedTotalElement = document.getElementById("effort_saved-total");
    if (effortSavedTotalElement) {
      effortSavedTotalElement.textContent = total.toFixed(2);
    }
    var manMonthTotalElement = document.getElementById("man_month-total");
    if (manMonthTotalElement) {
      manMonthTotalElement.textContent = (total / (8 * 22)).toFixed(2);
    }
  }

  var effortSavedInputs = document.querySelectorAll(".effort_saved-input");
  effortSavedInputs.forEach(function (input) {
    input.addEventListener("change", calculateTotal);
  });

  var repeatUnitSelects = document.querySelectorAll(".repeat_unit-select");
  repeatUnitSelects.forEach(function (input) {
    input.addEventListener("change", calculateTotal);
  });

  var repeatTimeSelects = document.querySelectorAll(".repeat_time-input");
  repeatTimeSelects.forEach(function (input) {
    input.addEventListener("change", calculateTotal);
  });

  calculateTotal();
};
