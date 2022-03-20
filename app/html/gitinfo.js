"use strict";

function setTableHeaders(fragment, tools) {
    var headerRow = $("<tr/>");
    headerRow.append($("<th>Repository</th>"));
    headerRow.append($("<th>Branch</th>"));
    headerRow.append($("<th>Commit</th>"));
    headerRow.addClass("header");
    $.each(tools, function() { headerRow.append($("<th>")); });
    headerRow.appendTo(fragment);
}

function setToolData(row, data, repo) {
    $.each(data.tools, function(index, toolName) {
        var tool = repo.tools[toolName];
        var cell = $("<td></td>");
        var div = $("<div></div>").addClass(`status-${tool.status}`).appendTo(cell);
        var link = $("<a>", {
            text: toolName,
            title: `Last run ${tool.date} - ${tool.status}`,
            href: `${repo.path}/${toolName}`,
        }).appendTo(div);
        row.append(cell);
    });
}

function setTableData(fragment, data) {
    $.each(data.repositories, function(repoId, repo) {
        var row = $("<tr/>");
        var project = $("<td></td>")
        var link = $("<a>", {
            text: repo.name,
            title: repo.name,
            href: repo.url
        });
        project.append(link);
        row.append(project);
        row.append($("<td></td>").text(repo.branch))
        row.append($("<td></td>").text(repo.commit))
        setToolData(row, data, repo);
        row.appendTo(fragment);
    });
}

function updateTable(data) {
    var fragment = new DocumentFragment();
    var statusTable = $("#status-table")[0];
    var newTable = statusTable.cloneNode();
    newTable.innerHTML = "";
    setTableHeaders(fragment, data.tools);
    setTableData(fragment, data);
    newTable.append(fragment);
    statusTable.parentNode.replaceChild(newTable, statusTable);
}

function updateStatus() {
    $.getJSON("status.json", updateTable);
}

$(document).ready(function(){
    updateStatus();
    setInterval(updateStatus, 10000);
});
