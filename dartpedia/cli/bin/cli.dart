import 'package:cli/cli.dart' as cli;

const version = '0.1.0';
void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');
  } else if (arguments.first == 'search') {
 
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);
  } else {
    printUsage();
  }
}


void searchWikipedia(List<String>? arguments){
  print('searchWikipedia received arguments: $arguments');
}

void printUsage(){
  print("The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'");
}
