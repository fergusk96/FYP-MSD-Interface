package Driver;


import static spark.Spark.get;
import static spark.Spark.staticFileLocation;
import static spark.Spark.port;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import TemplateEngine.FreeMarkerEngine;
import spark.ModelAndView;


public class MainClass {
    
    /**
     *  Entry Point
     * @param args
     */
    public static void main(String[] args) {
        staticFileLocation("/public"); /* Set location of images, css, js etc. This tells the
         								* Freemarker template engine
        								* where to look for files when a file is referenced inside
        								* html(ftl) file*/
        MainClass s = new MainClass();
        s.init(); //Initialise routes to methods that serve a user an element of the GUI
    }
    
    /**
     *  Function for Routes
     */
    private void init() {
    	
    	/* Read comments for the /artists and /artists:name routes
    	 * The rest of the routes work in virtually the same manner
		*/
    	
    	port(8081);
        get("/", (request, response) -> {
           Map<String, Object> argumentsMap = new HashMap<String, Object>();
           argumentsMap.put("title", "Search_here.."); 
           return new ModelAndView(argumentsMap, "songs.ftl"); //The songs interface is also the homepage
        }, new FreeMarkerEngine()); //Pass arguments to .ftl file and load in browser
        
        
        /*
         * The second argument to argumentsMap.put() is to be used as a 
    	 * search bar placeholder inside the .ftl file
    	 * It is referenced inside the ftl file using {$name}
    	 * which corresponds to the key of the map passed
    	 *  to the template engine file
         */
        
        get("/artists", (request, response) -> {
            Map<String, Object> argmentsMap = new HashMap<String, Object>();
            argmentsMap.put("name", "Search_here.."); 
            
            return new ModelAndView(argmentsMap, "artists.ftl");
         }, new FreeMarkerEngine());
        
        /* This time an artist name is passed instead of a placeholder. This is done when a user
         * has clicked an artist name. The Artist interface then appears with the clicked artist
         * preloaded
         */
        
        get("/artists/:name", (request, response) -> {
            Map<String, Object> argmentsMap = new HashMap<String, Object>();
            String name = URLEncoder.encode(request.params("name"), 
            		"UTF-8"); //Ensure all search querys are encoded in the same way
            argmentsMap.put("name", name);
            return new ModelAndView(argmentsMap, "artists.ftl");
         }, new FreeMarkerEngine());
        
        get("/songs", (request, response) -> {
            Map<String, Object> argmentsMap = new HashMap<String, Object>();
            argmentsMap.put("title", "Search_here.."); 
            return new ModelAndView(argmentsMap, "songs.ftl");
         }, new FreeMarkerEngine());
        get("/songs/:title", (request, response) -> {
            Map<String, Object> argmentsMap = new HashMap<String, Object>();
            String title = URLEncoder.encode(request.params("title"), "UTF-8");
            argmentsMap.put("title", title);
            return new ModelAndView(argmentsMap, "songs.ftl");
         }, new FreeMarkerEngine());
        get("/albums", (request, response) -> {
            Map<String, Object> argmentsMap = new HashMap<String, Object>();
            argmentsMap.put("name", "Search_here..");
            return new ModelAndView(argmentsMap, "albums.ftl");
         }, new FreeMarkerEngine());
        get("/albums/:name", (request, response) -> {
            Map<String, Object> argmentsMap = new HashMap<String, Object>();
            String name = URLEncoder.encode(request.params("name"), "UTF-8");
            argmentsMap.put("name", name);
            return new ModelAndView(argmentsMap, "albums.ftl");
         }, new FreeMarkerEngine());
        get("/tags", (request, response) -> {
            Map<String, Object> argmentsMap = new HashMap<String, Object>();
            argmentsMap.put("tag", "Search_here");
            return new ModelAndView(argmentsMap, "tags.ftl");
         }, new FreeMarkerEngine());
        get("/tags/:tag", (request, response) -> {
            Map<String, Object> argmentsMap = new HashMap<String, Object>();
            String tag = URLEncoder.encode(request.params("tag"), "UTF-8");
            argmentsMap.put("tag", tag);
            return new ModelAndView(argmentsMap, "tags.ftl");
         }, new FreeMarkerEngine());
        get("/similarSongs", (request, response) -> {
            Map<String, Object> argmentsMap = new HashMap<String, Object>();
            argmentsMap.put("title", "Search_here");
            return new ModelAndView(argmentsMap, "similarSongs.ftl");
         }, new FreeMarkerEngine());
        get("/similarArtists", (request, response) -> {
            Map<String, Object> argmentsMap = new HashMap<String, Object>();
            argmentsMap.put("title", "Search_here");
            return new ModelAndView(argmentsMap, "similarArtist.ftl");
         }, new FreeMarkerEngine());
        
      
        
        
        
    }
    

    
}
