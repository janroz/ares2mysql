<meta charset="utf-8">
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set("memory_limit", -1);

define("FOLDER", "VYSTUP/DATA/");
define("DONE_FOLDER", "VYSTUP/");

define("DB_PREFIX", "balik_");
define("DB_HOST", "localhost");
define("DB_NAME", "YOUR_DATABASE_NAME_HERE");
define("DB_USER", "YOUR_DATABASE_USERNAME_HERE");
define("DB_PASS", "YOUR_DATABASE_PASSWORD_HERE");

/** Insert a row into database.
 * @param db - PDO handler
 * @param table - table name
 * @param xmlNode - a SimpleXML node whose children correspond to the table's columns
 * @param columns - the columns which should be read from xmlNode
 * @param readyValues - prefilled column values
 */
function insert($db, $table, $xmlNode = null, $columns = [], $readyValues = []) {
  $q = "INSERT INTO `".DB_PREFIX.$table."`";
  $usedColumns = array_merge($columns, array_keys($readyValues));
  $namedColumns = array_merge($columns, array_filter(array_keys($readyValues), "is_string"));
  if (count($usedColumns) == 0) {
    $q .= " (id) VALUES (DEFAULT)"; // for inserting into tables with just 1 auto increment column
  } elseif (count($namedColumns) == 0) {
    $q .= " VALUES (".str_repeat("?,", count($usedColumns)-1)."?)"; // all columns (for m:n relations)
  } else {
    assert(count($usedColumns) == count($namedColumns));
    $q .= " (`".implode("`,`", $usedColumns)."`)".
          " VALUES (".str_repeat("?,", count($usedColumns)-1)."?)";
  }
  $stmt = $db->prepare($q);
  $values = [];
  foreach ($columns as $column) {
    $childNode = $xmlNode->xpath("are:" . $column);
    $values[] = count($childNode) > 0 ? ((string)($childNode[0])) : null;
  }
  foreach ($readyValues as $value) {
    $values[] = $value;
  }
  $stmt->execute($values);
  return $db->lastInsertId();
}

/** Insert an entity into the database. This uses the insert function.
 * The columns array has a special format to express various relationships.
 * @param db - PDO handler
 * @param table - table name
 * @param xmlNode - SimpleXML node whose subitems are inserted
 * @param columns - list of columns
 */
function insert_resursive($db, $table, $xmlNode, $columns) {
  $simpleColumns = [];
  $readyValues = [];
  $multiples = [];
  foreach ($columns as $key => $value) {
    if (is_numeric($key) && is_string($value)) {
      // a simple array
      $simpleColumns[] = $value;
    } elseif (count($value)==2 && isset($value[0]) && is_string($value[0]) && isset($value[1]) && is_array($value[1])) {
      assert(is_string($key));
      $elName = rtrim($key, '*');
      $fieldName = @array_pop(explode("/", $elName));
      list($childTable, $childItems) = $value;
      $childNodes = $xmlNode->xpath("are:".str_replace("/", "/are:", $elName));
      if (count($childNodes) > 0) {
        if (substr($key, -1) === '*') { // an array => 1:n saved as m:n (to be normalized)
          $multiples[$childTable] = ["columns" => $childItems, "children" => $childNodes];
        } else { // a structured item => 1:1 saved as 1:n (to be normalized)
          $readyValues[$fieldName] = insert_resursive($db, $childTable, $childNodes[0], $childItems);
        }
      } // otherwise the field is not in insert => default null / no relationship
    } else {
      throw new Exception("Assertion error");
    }
  }
  // special handling of Text fields + dza & dvy
  if (count($xmlNode->children()) == 0 && count($simpleColumns) == 1 && $simpleColumns[0] == "Text") {
    $readyValues[$simpleColumns[0]] = (string)$xmlNode;
    $attributes = $xmlNode->xpath("..")[0]->attributes();
    $simpleColumns = [];
    $xmlNode = null;
  } else {
    $attributes = $xmlNode->attributes();
  }
  if (!empty($attributes["dza"])) $readyValues["dza"] = $attributes["dza"];
  if (!empty($attributes["dvy"])) $readyValues["dvy"] = $attributes["dvy"];
  $id = insert($db, $table, $xmlNode, $simpleColumns, $readyValues);
  foreach ($multiples as $childTable => $childInfo) {
    foreach ($childInfo["children"] as $childNode) {
      $relative_id = insert_resursive($db, $childTable, $childNode, $childInfo["columns"]);
      $relationTable = "vazba_";
      if (strpos($childTable, $table."_") !== 0) $relationTable .= $table . "_";
      $relationTable .= $childTable;
      insert($db, $relationTable, null, [], [$id, $relative_id]);
    }
  }
  return $id;
}


$h = opendir(FOLDER);
while (false !== ($entry = readdir($h))) {
    if($entry != '.' && $entry != '..') { 
        $fileName = $entry;
        break;
    }
}
echo $fileName . "<br>\n";

$file = file_get_contents(FOLDER.$fileName);

$data = new SimpleXMLElement($file);

foreach($data->getDocNamespaces() as $strPrefix => $strNamespace) {
    if(strlen($strPrefix)==0) {
        $strPrefix="a"; // assign an arbitrary namespace prefix
    }
    $data->registerXPathNamespace($strPrefix,$strNamespace);
}

$db = new PDO('mysql:host='.DB_HOST.';dbname='.DB_NAME';charset=utf8', DB_USER, DB_PASS, array(PDO::ATTR_EMULATE_PREPARES => false,  PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
$db->beginTransaction();

define("TEXT_ARRAY", ["Text"]);
define("ADRESA_TYP", [
  "AdresaTyp", [
    "ruianKod",
    "stat",
    "psc",
    "okres",
    "obec",
    "castObce",
    "mop",
    "ulice",
    "cisloPop",
    "cisloOr",
    "cisloEv",
    "cisloTxt",
    "text",
    "doplnujiciText",
    "dorucovaciCislo",
    "skrytyUdaj/Text*" => ["AdresaTyp_skrytyUdaj", TEXT_ARRAY]
  ]
]);
define("PRAVNIFORMA_TYP", ["PravniFormaTyp", ["Kod_PF", "Nazev_PF"]]);
define("FOSOBA_TYP", [
  "adresa"=>ADRESA_TYP,
  "jmeno",
  "prijmeni",
  "datumNarozeni",
  "rodneCislo",
  "obcanstvi",
  "titulPred",
  "titulZa",
  "bydliste"=>ADRESA_TYP
]);
define("CLENSTVI_TYP", ["ClenstviTyp", ["vznikClenstvi", "zanikClenstvi"]]);
define("FUNKCE_TYP", ["FunkceTyp", ["nazev", "vznikFunkce", "zanikFunkce"]]);
define("POSOBA_TYP", [
  "adresa"=>ADRESA_TYP,
  "ICO",
  "ObchodniFirma",
  "PravniForma" => PRAVNIFORMA_TYP,
  "Zastoupeni*" => ["UdajTypuAngazmaClenstvi", [
    "clenstvi" => CLENSTVI_TYP,
    "funkce" => FUNKCE_TYP,
    "fosoba" => ["FyzickaOsobaTyp", FOSOBA_TYP],
  ]]
]);
define("CLEN_TYP", ["UdajTypuAngazmaClenstvi", [
  "clenstvi" => CLENSTVI_TYP,
  "funkce" => FUNKCE_TYP,
  "fosoba" => ["FyzickaOsobaTyp", FOSOBA_TYP],
  "posoba" => ["PravnickaOsobaTyp", POSOBA_TYP],
  "skrytyUdaj/Text*" => ["UdajTypuAngazmaClenstvi_skrytyUdaj", TEXT_ARRAY],
]]);


$odpoved = $data->xpath("//are:Odpoved")[0];
$pomocneId = (int)$odpoved->xpath("are:Pomocne_ID")[0];
$vypis = $odpoved->xpath("are:Vypis_VREO")[0];


insert_resursive($db, "VypisVrEo", $vypis, [
  "Uvod"=>["UvodTyp", [
    "Nadpis",
    "Aktualizace_DB",
    "Datum_vypisu",
    "Cas_vypisu",
    "Typ_vypisu",
    "Pozadovane_datum_platnosti_dat",
    "Typ_odkazu",
    "Typ_odpovedi"
  ]],
  "Zakladni_udaje" => ["ZakladniUdajeVr", [
    "Rejstrik",
    "ICO",
    "ObchodniFirma",
    "PravniForma"=>PRAVNIFORMA_TYP,
    "Sidlo"=>ADRESA_TYP,
    "Bydliste"=>ADRESA_TYP,
    "Pobyt"=>ADRESA_TYP,
    "DatumVzniku",
    "DatumZapisu",
    "DatumVymazu",
    "DuvodVymazu/Text*" => ["ZakladniUdajeVr_DuvodVymazu", TEXT_ARRAY],
    "StatusVerejneProspesnosti",
    "Cinnosti"=>["CinnostiTyp", [
      "PredmetPodnikani/Text*" => ["CinnostiTyp_PredmetPodnikani", TEXT_ARRAY],
      "DoplnkovaCinnost/Text*" => ["CinnostiTyp_DoplnkovaCinnost", TEXT_ARRAY],
      "PredmetCinnosti/Text*"  => ["CinnostiTyp_PredmetCinnosti", TEXT_ARRAY],
      "Ucel/Text*"             => ["CinnostiTyp_Ucel", TEXT_ARRAY],
    ]],
  ]],
  "Statutarni_organ*" => ["UdajTypuStatutar", [
    "Nazev",
    "ZpusobJednani/Text*" => ["ZpusobJednaniTyp", TEXT_ARRAY], // instead of ZpusobJednani*/Text*
    "Clen*" => CLEN_TYP,
  ]],
  "Jiny_organ*" => ["UdajTypuAngazma", [
    "Nazev",
    "Clen*" => CLEN_TYP,
  ]],
]);


$db->commit();
//unlink(FOLDER.$fileName);
rename(FOLDER.$fileName, DONE_FOLDER.$fileName);
echo '<meta http-equiv="refresh" content="0">';
?>

