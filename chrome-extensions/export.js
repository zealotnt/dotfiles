// Dump script
// https://stackoverflow.com/questions/17745292/how-to-retrieve-all-localstorage-items-without-knowing-the-keys-in-advance

// first, open chrome-extension option page
// then inspect the page
// then run this script in the console
function allStorage(included_keys) {

    var archive = {}, // Notice change here
        keys = Object.keys(localStorage),
        i = keys.length;

    while ( i-- ) {
        if (!included_keys.includes(keys[i])) continue;
        archive[ keys[i] ] = localStorage.getItem( keys[i] );
    }

    return archive;
}
// keys for wasavi, others extension may varies
included_keys = ['exrc', 'targets', 'shortcut', 'fontFamily']
console.log(JSON.stringify(allStorage(included_keys)))
// then right click to result -> Save as -> remove invalid json character -> jqip to format the file
