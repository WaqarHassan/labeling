# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

messagebox = ->
  className = $('.project-data').attr('class')
  console.log className
  if className == 'project-data collapsed'
    $('#projectbox').removeClass 'collapsed'
    $('#ghzanfer').removeClass 'tspend'
  else
    $('#projectbox').addClass 'collapsed'
    $('#ghzanfer').addClass 'tspend'
  return
