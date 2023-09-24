import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="is_released_select"
export default class extends Controller {
  connect() {}

  change(e) {
    e.preventDefault();
    const releasedAtFieldElement = document.getElementById(
      "released_at-select_date-field"
    );
    if (e.target.value == "released") releasedAtFieldElement.hidden = false;
    else releasedAtFieldElement.hidden = true;
  }
}
