$(function() {
  
  if ($('#payments-range').length > 0) {
    $('#payments-range').daterangepicker({
      presetRanges: [
        {text: 'This month', dateStart: function(){ return Date.parse('today').moveToFirstDayOfMonth();  }, dateEnd: function () { return Date.parse('today').moveToLastDayOfMonth() }},
        {text: 'Next 30 days', dateStart: 'today', dateEnd: 'today+30' },
        {text: 'Last Month',   dateStart: function(){ return Date.parse('today-1month').moveToFirstDayOfMonth();  }, dateEnd: function () { return Date.parse('today-1month').moveToLastDayOfMonth() }},
        {text: 'Last 30 days', dateStart: 'today-30', dateEnd: 'today' },
        {text: 'This week',    dateStart: function(){ return Date.parse('today-7days').monday(); }, dateEnd: function () { return Date.parse('today').sunday() }},
      ],
      presets: {dateRange: 'Date Range'},
      dateFormat: 'dd/mm/yy',
      onClose: function() {
        // Hack for daterange picker. Because onClose event fires earlier than value changes!
        setTimeout(function() {$("#payment-filter-form").submit();}, 100)
      }
    });
  }
  
  $("#payments-status").live('change', function(){
    $("#payment-filter-form").submit();
  })

});