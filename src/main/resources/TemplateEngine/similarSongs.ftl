<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="http://neo4j-contrib.github.io/developer-resources/language-guides/assets/css/main.css">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	<link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
    
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
                                <input type="text" placeholder="Search for song" class="form-control" name="songSearch" id="searchBar" value=${title}>
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
                <div style="margin-top: 8px;margin-left: 4px;">
                <a href="/albums" class="btn btn-default"  >Album</a>
                <a href="/artists" class="btn btn-default" >Artist</a>
                <a href="/songs" class="btn btn-default" >Song</a>
                <a href="/tags" class="btn btn-default">Tag/Genre</a>
                <a href="/similarSongs" class="btn btn-default" style="background-color: #008cc1;">Song Recommend</a>
                <a href="/similarArtists" class="btn btn-default">Artist Recommend</a>
                
                
                
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <div class="panel panel-default scrollable-panel">
            <div class="panel-heading">Search Results</div>
            <table id="results" class="table table-striped table-hover">
                <thead>
                <tr>
                <th>Song</th> 
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
    <div class="col-md-6">
        <div class="panel panel-default scrollable-panel" style="max-height: 300px;">
            <div class="panel-heading" id="name">Details</div>
            <table id="similar_table" class="table table-striped table-hover">
                <thead>
                <tr>
                    <th>Similar Song</th>
                    <th>Artist</th>
                    <th>Album</th>
                                     
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

            function similarSongs(songName, artistName) {
            $.get("http://ec2-34-241-1-61.eu-west-1.compute.amazonaws.com:8080/simSongs/"+ encodeURIComponent(songName)  +'/'+encodeURIComponent(artistName),
                    function (data) {
                        var t = $("table#similar_table tbody").empty();
                        if (!data || data.length == 0) return;
                        data.forEach(function (row) {
                            
                            $("<tr><td class='songs'>" + row['simSong.title'] + "</td><td>" + row['artist.name'] + "</td> <td>" + row['album.name'] + "</td></tr>").appendTo(t)
                                    .click(function() { window.open("/songs/" + ($(this).find("td.songs").text()));
                                        

                                })
                        });
                    }, "json");
            return false;
        }
        
   function songSearch() {
            var query=$("#songSearch").find("input[name=songSearch]").val();
            query = query.split('+').join(' ');
            query = query.split('%28').join('(');
            query = query.split('%29').join(')');   
            document.getElementById('searchBar').value = query         
            
            $.get("http://ec2-34-241-1-61.eu-west-1.compute.amazonaws.com:8080/songSearch?q=" + encodeURIComponent(query),
                    function (data) {
                        
                        var t = $("table#results tbody").empty();
                        if (!data || data.length == 0) return;
                        data.forEach(function (row) {
                            var song = row;
                            $("<tr><td class='song'>" + song["song.title"] + "</td><td class='artist' >" + song["artist.name"] + "</td><td >" + song["album.name"] + "</td><td >" + song["year.year"] + "</td></tr>").appendTo(t)
                                    .click(function() { similarSongs($(this).find("td.song").text(),$(this).find("td.artist").text());;

                                })
                        });
                        similarSongs(data[0]["song.title"]);
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
    d3.json("http://ec2-34-241-1-61.eu-west-1.compute.amazonaws.com:8080/graph", function(error, graph) {
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