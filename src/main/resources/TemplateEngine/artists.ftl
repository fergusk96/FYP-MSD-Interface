<html>
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
                        <form role="artistSearch" class="navbar-form" id="artistSearch">
                            <div class="form-group">
                                <input type="text"  placeholder="Search for Artist" class="form-control" id='searchBar' name="artistSearch" value=${name}>
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
                <a href="/albums" class="btn btn-default">Album</a>
                <a href="/artists" class="btn btn-default" style="background-color: #008cc1;" >Artist</a>
                <a href="/songs" class="btn btn-default" >Song</a>
                <a href="/tags" class="btn btn-default">Tag/Genre</a>
                <a href="/similarSongs" class="btn btn-default">Song Recommend</a>
                <a href="/similarArtists" class="btn btn-default">Artist Recommend</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-5">
        <div class="panel panel-default scrollable-panel scrollable-panel">
            <div class="panel-heading">Search Results</div>
            <table id="results" class="table table-striped table-hover">
                <thead>
                <tr>

                    
                    <th>Artist</th>
                   
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    <div class="panel panel-default scrollable-panel scrollable-panel">
            <div class="panel-heading">Search Results</div>
            <table id="albums_table" class="table table-striped table-hover">
                <thead>
                <tr>

                    
                    <th>Albums</th>
                   
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <div class="col-md-7">
        <div class="panel panel-default scrollable-panel">
            <div class="panel-heading" id="name">Details</div>
            <table id="song_table" class="table table-striped table-hover">
                <thead>
                <tr>

                    <th>Song</th>
                    <th>Year</th>
                   
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
                     <div class="col-md-10" style="width: 103%;padding-left: 1px !important;">
        <div class="panel panel-default scrollable-panel">
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
  function showArtist(name) {
            $.get("http://ec2-34-241-1-61.eu-west-1.compute.amazonaws.com:8080/artist/" + encodeURIComponent(name),
                    function (data) {
                        var r = $("table#song_table tbody").empty();
                        data=data[0];
                        if (!data) return;
                        $("#name").text(data.name);
                        var $list = $("#crew").empty();
                        data[0].songs.forEach(function (songs) {
       
                    $("<tr><td class='songs'>" + songs.title + "</td><td>" + songs.year + "</td></tr>").appendTo(r)
	                                    .click(function() {window.open("/songs/" + ($(this).find("td.songs").text()) ); })                     
                        });
                    }, "json");
            return false;
        }
  
	function showTag(name){
	        $.get("http://ec2-34-241-1-61.eu-west-1.compute.amazonaws.com:8080/artist/" + encodeURIComponent(name),
	             function (data) {
	                data = data[2]
	        var r = $("table#tag_table tbody").empty();
	         if (!data) return;
	         data[0].Tags.forEach(function (tags) {
	                        $("<tr><td class='tags'>" + tags.Tag + "</td><</tr>").appendTo(r)
	                                .click(function() {window.open("/tags/" + ($(this).find("td.tags").text()) ); })                     
	                        
	                   });
	                }, "json");
	        return false;
	    }
	function showAlbum(name){
	        $.get("http://ec2-34-241-1-61.eu-west-1.compute.amazonaws.com:8080/artist/" + encodeURIComponent(name),
	             function (data) {
	                data = data[1]
	        var r = $("table#albums_table tbody").empty();
	         if (!data) return;
	         data[0].albums.forEach(function (albums) {
	                        $("<tr><td class='albums'>" + albums.album + "</td><</tr>").appendTo(r)
	                                .click(function() {window.open("/album/" + ($(this).find("td.albums").text()) ); })                     
	                        
	                   });
	                }, "json");
	        return false;
	    }
        
        function artistSearch() {
            var query=$("#artistSearch").find("input[name=artistSearch]").val();
            query = query.split('+').join(' ');
            query = query.split('%28').join('(');
            query = query.split('%29').join(')');   
            document.getElementById('searchBar').value = query         
            $.get("http://ec2-34-241-1-61.eu-west-1.compute.amazonaws.com:8080/artistSearch?q=" + encodeURIComponent(query),
                    function (data) {
                        var t = $("table#results tbody").empty();
                        if (!data || data.length == 0) return;
                        data.forEach(function (row) {
                            var artist = row.artist;
                            $("<tr><td class='artist'>" + artist.name + "</td></tr>").appendTo(t)
                                    .click(function() { showArtist($(this).find("td.artist").text());
                                    			showTag($(this).find("td.artist").text());
							showAlbum($(this).find("td.artist").text());
							
                                    })
                        });
                        showArtist(data[0].artist.name);
                        showTag(data[0].artist.name);
                    }, "json");
            return false;
        }
        $("#artistSearch").submit(artistSearch);
        artistSearch();
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
