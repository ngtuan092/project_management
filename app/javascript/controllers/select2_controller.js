import { Controller } from "@hotwired/stimulus"
import $ from 'jquery';
import Select2 from "select2"

export default class extends Controller {
  connect() {
    Select2()
    $('.select2').select2();
  }
}
