package dox.inject._internal.schema;

/**
 * Documentation for a class. Should be placed in `docs/<package>/<module>.json`.
 */
typedef ClassDocs = {
    /**
     * A string representing the documentation for the class.
     */
    var ?classDoc:String;

    var ?fieldDocs:Array<FieldDoc>;
}

/**
 * Documentation for an individual field.
 */
typedef FieldDoc = {
    /**
     * The name of the field to document.
     * TODO: How to handle overloads?
     */
    var ?name:String;

    /**
     * A string representing the documentation for the field.
     */
    var ?doc:String;
}