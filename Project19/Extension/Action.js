var Action = function() {  }

Action.prototype = {
    
// that`s called before your extension run
run: function(parameters) {
    parameters.completionFunction({"URL": document.URL, "title": document.title});
},
// and after it`s been run
finalize: function(parameters) {
    var customJavaScript = parameters["customJavaScript"]; // "cutomJavaScript" - the name exactly the same as in argument parameter in ActionVC!
    eval(customJavaScript);
}
    
    
};

var ExtensionPreprocessingJS = new Action

