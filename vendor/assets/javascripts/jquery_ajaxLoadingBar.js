(function() {
  (function($) {
    return $.fn.ajaxLoadingBar = function(options) {
      var settings;
      settings = $.extend({
        turbolinks: true,
        ajax: true
      }, options);
      if (settings.turbolinks) {
        $(document).on('page:fetch', function() {
          return window.pageLoader.startRequest();
        });
        $(document).on('page:receive', function() {
          return window.pageLoader.sliderWidth = $('#pageLoader').width();
        });
        $(document).on('page:load', function() {
          return window.pageLoader.endRequest();
        });
        $(document).on('page:restore', function() {
          window.pageLoader.startRequest();
          return window.pageLoader.endRequest();
        });
      }
      if (settings.ajax) {
        $(document).ajaxComplete(function(e) {
          return window.pageLoader.endRequest();
        });
        $(document).ajaxStart(function() {
          return window.pageLoader.startRequest();
        });
      }
      return window.pageLoader = {
        sliderWidth: 0,
        requestsInProgress: 0,
        startLoader: function() {
          $('#pageLoader').remove();
          return $('<div/>', {
            id: 'pageLoader'
          }).appendTo('body').animate({
            width: $(document).width() * .4
          }, 2000).animate({
            width: $(document).width() * .6
          }, 6000).animate({
            width: $(document).width() * .90
          }, 10000).animate({
            width: $(document).width() * .99
          }, 20000);
        },
        finishLoader: function(){
          $('#pageLoader').remove();
          return $('<div/>', {
            id: 'pageLoader'
          }).css({
            width: window.pageLoader.sliderWidth
          }).appendTo('body').animate({
            width: $(document).width()
          }, 500).fadeOut(function() {
            return $(this).remove();
          });
        },
        startRequest: function() {
          var pending = window.pageLoader.requestsInProgress;
          pending += 1;
          if(pending == 1)
            window.pageLoader.startLoader();
          window.pageLoader.requestsInProgress = pending;
        },
        endRequest: function() {
          var pending = window.pageLoader.requestsInProgress;
          pending -= 1;
          if(pending < 0)
            pending = 0
          if(pending == 0)
            window.pageLoader.finishLoader();
          window.pageLoader.requestsInProgress = pending;
        }
      };
    };
  })(jQuery);

}).call(this);