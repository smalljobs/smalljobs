$(document).ready(function() {
  var tableSorted = [false, false, false, false, false];
  var options = {
    valueNames: [ 'name', 'provider-name', 'place', 'status',
    'street', 'title', 'date', 'allocations', 'jobs', 'status', 'payment',
    'feedback', 'description', 'salary', 'manpower', 'duration',
    'long_description', 'short_description', 'phone',
    'mobile', 'contact_preference', 'contact_availability', 'company',
    'email', 'sex', 'additional_contacts', 'occupation', 'languages',
    'age', 'rc_username', 'id' ]
  };
  window.jobsList = null
  window.todosCurrentList = null
  window.todosPostponedList = null
  window.providersList = null
  window.assignmentsList = null
  window.seekersList = null
  var target = window.location.hash;
  target = target.replace('#', '');
  if(target === '') {
    target = 'todo';
  }
  var newHash = target;

  if (newHash === 'todo' || newHash === 'todos' || newHash === 'todo_postponed' || newHash === 'todo_current') {
    initTable()
  }

  $('#dashboard .nav-pills a').on('shown.bs.tab', function (e) {
    initTable();
  })

  function initTable() {
    const activeTabId = $('#dashboard .nav-pills').find('.active > a').attr('href')
    if (activeTabId === '#jobs' && $(`${activeTabId} #jobs-table-to-insert`).length){
      getTableHtml('jobs', () => {
        window.jobsList = new List('jobs', options);
        loadSortedColumn();
      })
    } else if (activeTabId === '#jobs' && $('.jobs-table-inserted').length) {
      // loadSortedColumn()
    } else if (activeTabId === '#todos' && $(`${activeTabId} #todos-table-to-insert`).length){
      getTableHtml('todos', () => {
        window.todosCurrentList = new List('todo_current', options);
        window.todosPostponedList = new List('todo_postponed', options);
        loadSortedColumn();
      })
    } else if (activeTabId === '#todos' && $('.todos-table-inserted').length) {
      // loadSortedColumn()
    } else if (activeTabId === '#providers' && $(`${activeTabId} #providers-table-to-insert`).length){
      getTableHtml('providers', () => {
        window.providersList = new List('providers', options);
        loadSortedColumn();
      })
    } else if (activeTabId === '#providers' && $('.providers-table-inserted').length) {
      // loadSortedColumn()
    } else if (activeTabId === '#assignments' && $(`${activeTabId} #assignments-table-to-insert`).length){
      getTableHtml('assignments', () => {
        window.assignmentsList = new List('assignments', options);
        loadSortedColumn();
      })
    } else if (activeTabId === '#assignments' && $('.assignments-table-inserted').length) {
      // loadSortedColumn()
    } else if (activeTabId === '#seekers' && $(`${activeTabId} #seekers-table-to-insert`).length){
      getTableHtml('seekers', () => {
        window.seekersList = new List('seekers', options);
        loadSortedColumn();
        reInitInboxChat()
      })
    } else if (activeTabId === '#seekers' && $('.seekers-table-inserted').length) {

      // loadSortedColumn()
    }
  }

  function loadSortedColumn() {
    var hash = target;
    var sortedColumnId = sessionStorage.getItem('sortedColumn' + hash);
    if(sortedColumnId != undefined) {
      sorttable.init(false);
      sorttable.innerSortFunction.apply(document.getElementById(sortedColumnId), []);
      if(sessionStorage.getItem('sortedReverse' + hash) === 'true') {
        sorttable.innerSortFunction.apply(document.getElementById(sortedColumnId), []);
      }
    } else {
      sorttable.init(false);
      if(hash === "todo" && !tableSorted[0]) {
        tableSorted[0] = true;
        sorttable.innerSortFunction.apply(document.getElementById('todo_date'), []);
        // sorttable.innerSortFunction.apply(document.getElementById('todo_date'), []);
      }
      if(hash === "jobs" && !tableSorted[1]) {
        tableSorted[1] = true;
        sorttable.innerSortFunction.apply(document.getElementById('job_date'), []);
        // sorttable.innerSortFunction.apply(document.getElementById('job_date'), []);
      }
      if(hash === "providers" && !tableSorted[2]) {
        tableSorted[2] = true;
        sorttable.innerSortFunction.apply(document.getElementById('provider_date'), []);
        // sorttable.innerSortFunction.apply(document.getElementById('provider_date'), []);
      }
      if(hash === "seekers" && !tableSorted[3]) {
        tableSorted[3] = true;
        sorttable.innerSortFunction.apply(document.getElementById('seeker_date'), []);
        // sorttable.innerSortFunction.apply(document.getElementById('seeker_date'), []);
      }
      if(hash === "assignments" && !tableSorted[4]) {
        tableSorted[4] = true;
        sorttable.innerSortFunction.apply(document.getElementById('assignment_date'), []);
        // sorttable.innerSortFunction.apply(document.getElementById('assignment_date'), []);
      }
    }
  }

  function getTableHtml(id, successCallback) {
    $.ajax({
      url: `/broker/dashboard/${id}_table`,
      type: 'GET',
      success: function(result) {
        const tempDiv = $('<div>').html(result);
        const elementToReplace = $(`#${id} #${id}-table-to-insert`)
        if (id === 'todos') {
          const firstTodoElement = tempDiv.find('#todo_current');
          if (firstTodoElement.length > 0) {
            elementToReplace.parent().append(firstTodoElement);
          }
          const secondTodoElement = tempDiv.find('#todo_postponed')
          if (secondTodoElement.length > 0) {
            elementToReplace.parent().append(secondTodoElement);
            elementToReplace.remove()
            successCallback()
          }
        } else {
          const tableResponsive = tempDiv.find('.table-responsive');
          if (tableResponsive.length > 0) {
            elementToReplace.parent().append(tableResponsive);
            elementToReplace.remove()
            successCallback()
          }
        }
      },
      error: function(result){
        console.log(result.responseJSON.error)
      }
    });
  }
})
