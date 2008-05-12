// ==UserScript==
// @name           Rails Lighthouse Linker
// @namespace      http://sjjdev.com/lighthouselinker
// @include        http://github.com/*/rails/commit/*
// ==/UserScript==

var pre = document.getElementsByClassName("message")[0].childNodes[0];
if (pre)
{
  var norm = pre.innerHTML.replace('\n', '')
  var results = norm.match(/\[#([0-9]+).*\]/);
  if (results)
  {
    pre.innerHTML = norm.replace(results[0], '\n<a href="http://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/' + results[1] + '">' + results[0] + '</a>\n\n')
  }
}