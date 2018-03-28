<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="http://neo4j-contrib.github.io/developer-resources/language-guides/assets/css/main.css">
    
</head>

<body>
<div id="graph">
</div>
<div role="navigation" class="navbar navbar-default navbar-static-top">
    <div class="container">
        <div class="row">
            <div class="col-sm-6 col-md-6">
                <ul class="nav navbar-nav">
                    <li>
                        <form role="songSearch" class="navbar-form" id="songSearch">
                            <div class="form-group">
                                <input type="text"  placeholder="Search for song" class="form-control" name="songSearch">
                            </div>
                            <button class="btn btn-default" type="submit">Search</button>
                        </form>
                    </li>
                </ul>
            </div>
            <div class="navbar-header col-sm-6 col-md-6">
                <div class="logo-well">
                    <a href="http://neo4j.com/developer-resources">
                    <img src="http://neo4j-contrib.github.io/developer-resources/language-guides/assets/img/logo-white.svg" alt="Neo4j World's Leading Graph Database" id="logo">
                    </a>
                </div>
                <div class="navbar-brand">
                    <div class="brand">MSD Interface</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-8">
        <div class="panel panel-default">
            <div class="panel-heading">Search Results</div>
            <table id="results" class="table table-striped table-hover">
                <thead>
                <tr>
                    <th>Title</th>
                    <th>Duration</th>
                    <th>Tempo</th>
                    <th>Loudness</th>
                    <th>Beats Per Bar</th>  

                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-default">
            <div class="panel-heading" id="name">Details</div>
            <table id="song_table" class="table table-striped table-hover">
                <thead>
                <tr>

                    <th>Artist</th>
                    <th>Album</th>
                    <th>Year</th>
                   
                
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-default">
            <div class="panel-heading" id="name">Tags</div>
            <table id="tag_table" class="table table-striped table-hover">
                <thead>
                <tr>

                    <th>Tag</th>
 
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>


</div>
<style type="text/css">
    .node { stroke: #222; stroke-width: 1.5px; }
    .node.actor { fill: #888; }
    .node.movie { fill: #BBB; }
    .link { stroke: #999; stroke-opacity: .6; stroke-width: 1px; }
</style>
<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://d3js.org/d3.v3.min.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        function showSong(name) {
            $.get("http://localhost:8080/song/" + encodeURIComponent(name),
                    function (data) {
                        data = data[0]
                        var r = $("table#song_table tbody").empty();

                        $("#name").text(data.name);
                        var $list = $("#crew").empty();
                        var keys = Object.keys(data[0].details[0]);
                            $("<tr><td class='songs'>" + data[0].details[0][keys[0]] + "</td><td>" + data[0].details[0][keys[2]] + "</td><td>" + data[0].details[0][keys[1]] + "</td></tr>").appendTo(r)
                                    .click(function() { showSong($(this).find("td.movie").text());})
                        
                    }, "json");
            return false;
        }

        function showTag(name){
             $.get("http://localhost:8080/song/" + encodeURIComponent(name),
                    function (data) {
                    data = data[1]
            var r = $("table#tag_table tbody").empty();
             if (!data) return;
             data[0].tags.forEach(function (tags) {
                            $("<tr><td class='tags'>" + tags.tag + "</td><</tr>").appendTo(r)
                                    .click(function() { showArtist($(this).find("td.movie").text());})
                            
                       });
                    }, "json");
            return false;
        }
        function songSearch() {
            var query=$("#songSearch").find("input[name=songSearch]").val();
            $.get("http://localhost:8080/songSearch?q=" + encodeURIComponent(query),
                    function (data) {
                        
                        var t = $("table#results tbody").empty();
                        if (!data || data.length == 0) return;
                        data.forEach(function (row) {
                            var song = row.song;
                            $("<tr><td class='song'>" + song.title + "</td><td>" + song.duration + "</td><td >" + song.tempo + "</td><td>" + song.loudness + "</td><td>" + song.beats_per_bar + "</td></tr>").appendTo(t)
                                    .click(function() { showSong($(this).find("td.song").text());
                                    	showTag($(this).find("td.song").text());

                                })
                        });
                        showSong(data[0].song.name);
                        showTag(data[0].song.name);
                    }, "json");
            return false;
        }
        $("#songSearch").submit(songSearch);
        songSearch();
    })
</script>

<script type="text/javascript">
    var width = 800, height = 800;
    var force = d3.layout.force()
            .charge(-200).linkDistance(30).size([width, height]);
    var svg = d3.select("#graph").append("svg")
            .attr("width", "100%").attr("height", "100%")
            .attr("pointer-events", "all");
    d3.json("/graph", function(error, graph) {
		if (error) return;
		
        force.nodes(graph.nodes).links(graph.links).start();
        var link = svg.selectAll(".link")
                .data(graph.links).enter()
                .append("line").attr("class", "link");
        var node = svg.selectAll(".node")
                .data(graph.nodes).enter()
                .append("circle")
                .attr("class", function (d) { return "node "+d.label })
                .attr("r", 10)
                .call(force.drag);
        // html name attribute
        node.append("name")
                .text(function (d) { return d.name; })
        // force feed algo ticks
        force.on("tick", function() {
            link.attr("x1", function(d) { return d.source.x; })
                    .attr("y1", function(d) { return d.source.y; })
                    .attr("x2", function(d) { return d.target.x; })
                    .attr("y2", function(d) { return d.target.y; });
            node.attr("cx", function(d) { return d.x; })
                    .attr("cy", function(d) { return d.y; });
        });
    });
</script>
</body>
</html>