$(document).ready(() => {
  $('#customer_description > p:first-child').removeClass('d-none');
  $('#customer_select').on('change', (e) => {
    const value = $('#customer_select').val();
    $('#customer_description > p').addClass('d-none');
    $('#customer_description_' + value).removeClass('d-none');
  })
})
