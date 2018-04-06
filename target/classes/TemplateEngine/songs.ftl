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
                <a href="/songs" class="btn btn-default" style="background-color: #008cc1;">Song</a>
                <a href="/tags" class="btn btn-default">Tag/Genre</a>
                <a href="/similarSongs" class="btn btn-default">Song Recommend</a>
                <a href="/similarArtists" class="btn btn-default">Artist Recommend</a>
                
                
                
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    
    <div class="col-md-6">
        <div class="panel panel-default scrollable-panel">
            <div class="panel-heading" id="name">Details</div>
            <table id="song_table" class="table table-striped table-hover">
                <thead>
                <tr>
					<th>Title</th>
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
        <div class="panel panel-default scrollable-panel" <div class="panel panel-default scrollable-panel" style="max-height: 600px;overflow: scroll;">
            <div class="panel-heading">Search Results
            <div class="btn-group" style="position: relative;left: 50%;">
                <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">Choose Data to Download<span class="caret"></span></button>
                <ul class="dropdown-menu">
                    <li><a onclick="downloadData('tatums')">Tatums</a></li>
                    <li><a onclick="downloadData('bars')">Bars</a></li>
                    <li><a onclick="downloadData('beats')">Beats</a></li>
                    <li><a onclick="downloadData('sections')">Sections</a></li>
                    <li><a onclick="downloadData('segments')">Segments</a></li>                   
                    <li><a onclick="downloadSegmentsData('pitches')">Segments Pitches</a></li>
                    <li><a onclick="downloadSegmentsData('timbre')">Segments Timbre</a></li>
                </ul>
            </div>
            
            </div>
            
            <table id="results" class="table table-striped table-hover">
                <thead>
                <tr>
                    
                    <th>Duration</th>
                    <th>Tempo</th>
                    <th>Loudness</th>
                    <th>Beats Per Bar</th>  
                    <th>Mode</th>  
                    <th>Key</th>  
                    

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
<style type="text/css">
    .node { stroke: #222; stroke-width: 1.5px; }
    .node.actor { fill: #888; }
    .node.movie { fill: #BBB; }
    .link { stroke: #999; stroke-opacity: .6; stroke-width: 1px; }
</style>
<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://d3js.org/d3.v3.min.js" type="text/javascript"></script>

<script type="text/javascript">
	var curArtist = "lady gaga";
	var curSong = "poker face";

	function downloadSegmentsData(type) {
            $.get("http://localhost:8080/segmentdetails/"+type+"/"+curSong+"/"+curArtist,
                    function (myData) {
                    	var csv = "";
                        var data,fileName,link;
                        csv = myData[0]['spt.segments_timbre'];                        
                        csv = csv.split(']').join('\n');
                        csv = csv.split('[[').join('');
                        csv = csv.split(', [').join('');
                        csv = csv.split('[').join('');
                        csv = type+ " per segment \n" + csv;

        if (csv == null) return;

        filename = curArtist+'_'+curSong+'_'+type+'.csv';

        if (!csv.match(/^data:text\/csv/i)) {
            csv = 'data:text/csv;charset=utf-8,' + csv;
        }
        data = encodeURI(csv);

        link = document.createElement('a');
        link.setAttribute('href', data);
        link.setAttribute('download', filename);
        link.click();
        
                    }, "json");
            return false;
        }
	
	function downloadData(type) {
            $.get("http://localhost:8080/songdetails/"+type+"/"+curSong+"/"+curArtist,
                    function (myData) {
                    	var csv = "";
                        var data,fileName,link;
                        if(type == 'tatums'){
                        csv = myData[0].tatums_start_point;}
                        else if(type == 'bars'){
                        csv = myData[0].bars_start_point;}
                        
                        else if(type == 'beats'){
                        csv = myData[0].beats_start_point;}
                        else if(type == 'segments'){
                        csv = myData[0].segments_start_point;}
                        
                        else{
                        csv = myData[0].sections_start_point;}
                        
                        csv = csv.split(',').join('\n');
                        csv = type+ " Start \n" + csv

        if (csv == null) return;

        filename = curArtist+'_'+curSong+'_'+type+'.csv';

        if (!csv.match(/^data:text\/csv/i)) {
            csv = 'data:text/csv;charset=utf-8,' + csv;
        }
        data = encodeURI(csv);

        link = document.createElement('a');
        link.setAttribute('href', data);
        link.setAttribute('download', filename);
        link.click();
        
                    }, "json");
            return false;
        }
    $(function () {
        function showSong(songTitle,artistName) {
            $.get("http://localhost:8080/song/artist/" + encodeURIComponent(songTitle)+'/'+encodeURIComponent(artistName),
                    function (data) {
                        data = data[0]
                        var r = $("table#results tbody").empty();

                        $("#name").text(data.name);
                        var $list = $("#crew").empty();
                            $("<tr><td class='songs'>" + data[0].duration + "</td><td>" + data[0].tempo + "</td><td>" + data[0].loudness + "</td><td>" + data[0].beats_per_bar + "</td><td>" + data[0].mode + "</td><td>" + data[0].key + "</td></tr>").appendTo(r)
                                    .click(function() { showSong($(this).find("td.movie").text());})
                        
                    }, "json");
            return false;
        }

        function showTag(songTitle,artistName){
            $.get("http://localhost:8080/song/artist/" + encodeURIComponent(songTitle)+'/'+encodeURIComponent(artistName),
                 function (data) {
                    data = data[1]
            var r = $("table#tag_table tbody").empty();
             if (!data) return;
             data[0].tags.forEach(function (tags) {
                            $("<tr><td class='tags'>" + tags.tag + "</td><</tr>").appendTo(r)
                                    .click(function() {window.open("/tags/" + ($(this).find("td.tags").text()) ); })                     
                            
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
            
            $.get("http://localhost:8080/songSearch?q=" + encodeURIComponent(query),
                    function (data) {
                        
                        var t = $("table#song_table tbody").empty();
                        if (!data || data.length == 0) return;
                        data.forEach(function (row) {
                            var song = row;
                            $("<tr><td class='song'>" + song["song.title"] + "</td><td class='artist' >" + song["artist.name"] + "</td><td >" + song["album.name"] + "</td><td >" + song["year.year"] + "</td></tr>").appendTo(t)
                                    .click(function() { showSong($(this).find("td.song").text(),$(this).find("td.artist").text());
                                    	showTag($(this).find("td.song").text(),$(this).find("td.artist").text());
            	                        curSong = $(this).find("td.song").text();
                        				curArtist = $(this).find("td.artist").text();

                                })
                        });
                        showSong(data[0]["song.title"], data[0]["artist.name"]);
                        showTag(data[0]["song.title"],data[0]["artist.name"]);
                        curArtist = data[0]["artist.name"];
                        curSong = data[0]["song.title"];
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