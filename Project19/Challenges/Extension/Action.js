// When we click on button with the name of our Extension this pre file works firstly then our extension works
var Action = function() {  }

// we add to our function method
Action.prototype = {
    

    
//inside we`ve got one function that`s called run
// that`s called before your extension is run
run: function(parameters) {
    // tell IOS with this completionFunction that JS has finished its pre-processing and give the data as this dict back to our extension
    parameters.completionFunction({"URL": document.URL, "title": document.title});
},
// hat`s called it`s been run
finalize: function(parameters) {
    var customJavaScript = parameters["customJavaScript"]; // "cutomJavaScript" - the name exactly the same as in argument parameter in ActionVC!
    eval(customJavaScript);
}
    
    
};

// we finish our script here and wrapped our func Action to a variable
var ExtensionPreprocessingJS = new Action

