<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/main.css">
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
                        <form role="albumSearch" class="navbar-form" id="albumSearch">
                            <div class="form-group">
                                <input type="text" placeholder="Search for Album" class="form-control" name="albumSearch" id="searchBar" value=${name}>
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
                <a href="/albums" class="btn btn-default" style="background-color: #008cc1;" >Album</a>
                <a href="/artists" class="btn btn-default">Artist</a>
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

					<th>Album</th>
                    <th>Artist</th>
                   
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
            <table id="album_table" class="table table-striped table-hover">
                <thead>
                <tr>

                    <th>Cover Art</th>
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
            <table id="Song_table" class="table table-striped table-hover">
                <thead>
                <tr>

                    <th>Song</th>
 
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
<style type="text/css">
	.albumRow{
	padding-top: 10px
	}
</style>
<style type="text/css">
    .mywell {
  min-height: 20px;
  padding: 4px;
  margin-bottom: 4px;
  background-color: #f5f5f5;
  border: 1px solid #e3e3e3;
  border-radius: 4px;
  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
  box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
}
</style>

<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://d3js.org/d3.v3.min.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
 function showAlbum(albumName,artistName) {
            $.get("http://localhost:8080/album/artist/" + encodeURIComponent(albumName) + "/"+encodeURIComponent(artistName),
                    function (data) {
                        var r = $("table#album_table tbody").empty();
                        imageData = data[0]
                        if (!data) return;
                        $("#name").text(data.name);
                      
                        var mySrc =  "<img src="+imageData.response[0].url+" class='mywell' id='poster' height='140' width='120'>";
                        var $list = $("#crew").empty();
                        $("<tr><td>"+mySrc+"</td> <td class='album'>" + imageData.response[imageData.response.length - 1] + "</td></tr>").appendTo(r)
                                    .click(function() {window.open("/albums/" + ($(this).find("td.album").text()) ); })                     
                        }, "json");
  
            return false;
        }
         function showSong(albumName,artistName) {
            $.get("http://localhost:8080/album/artist/" + encodeURIComponent(albumName) + "/"+encodeURIComponent(artistName),
                    function (data) {
                        var r = $("table#song_table tbody").empty();
                        albumData = data[1]
                        if (!data) return;
                        $("#name").text(data.name);
                      
                       albumData.Songs.forEach(function (songs) {
       
                    	$("<tr><td class='songs'>" + songs + "</td></tr>").appendTo(r)
	                                    .click(function() {window.open("/songs/" + ($(this).find("td.songs").text())); })                     
                        });
                        }, "json");
  
            return false;
        }


        function albumSearch() {
            var query=$("#albumSearch").find("input[name=albumSearch]").val();
            query = query.split('+').join(' ');
            query = query.split('%28').join('(');
            query = query.split('%29').join(')');
                                    
            $.get("http://localhost:8080/albumSearch?q=" + encodeURIComponent(query),
                    function (data) {
                          var t = $("table#results tbody").empty();
                        if (!data || data.length == 0) return;
                        data.forEach(function (row) {
                            var album = row.album;
                            $("<tr><td class='album albumRow'>" + album.name + "</td><td class='albumRow artist'>" + row["artist.name"] + "</td></tr>").appendTo(t)
                                    .click(function() { showAlbum($(this).find("td.album").text(),$(this).find("td.artist").text());
                                    					showSong($(this).find("td.album").text(),$(this).find("td.artist").text());})
                                    	

                                })
                        showAlbum(data[0].album.name, data[0]['artist.name']);
                        showSong(data[0].album.name, data[0]['artist.name']);
                    }, "json");
            return false;
        }
        $("#albumSearch").submit(albumSearch);
        albumSearch();
    })
</script>

<script type="text/javascript">
    var width = 800, height = 800;
    var force = d3.layout.force()
            .charge(-200).linkDistance(30).size([width, height]);
    var svg = d3.select("#graph").append("svg")
            .attr("width", "100%").attr("height", "100%")
            .attr("pointer-events", "all");
    d3.json("http://localhost:8080/graph", function(error, graph) {
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
        // html title attribute
        node.append("title")
                .text(function (d) { return d.title; })
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