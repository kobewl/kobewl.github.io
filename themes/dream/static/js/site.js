// 页面加载完成后执行
$(document).ready(function() {
  // 初始化侧边栏菜单
  $('.ui.sidebar').sidebar({
    context: $('.bottom.segment')
  }).sidebar('attach events', '.menu .item');
  
  // 初始化下拉菜单
  $('.ui.dropdown').dropdown();
  
  // 为具有tooltip属性的元素添加工具提示
  $('[data-tooltip]').popup();
  
  // 图片懒加载
  $("img.lazy").lazyload({
    effect: "fadeIn"
  });
  
  // 代码高亮
  $('pre code').each(function(i, block) {
    hljs.highlightBlock(block);
  });
  
  // 响应式设计 - 移动设备菜单适配
  if($(window).width() < 768) {
    $('.dream-sidebar').addClass('mobile-only');
  }
  
  $(window).resize(function() {
    if($(window).width() < 768) {
      $('.dream-sidebar').addClass('mobile-only');
    } else {
      $('.dream-sidebar').removeClass('mobile-only');
    }
  });
}); 