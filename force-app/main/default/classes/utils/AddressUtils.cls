@SuppressWarnings('PMD.StdCyclomaticComplexity,PMD.ExcessiveParameterList')
global class AddressUtils{

	private static final Map<String, String> SUFFIX_MAP = new Map<String, String>{
		'b' => 'bis',
		't' => 'ter',
		'q' => 'quater',
		'qn' => 'quinquies'
	};

	private static final String STREET_TYPES_PATTERN =
		'(?i)(rue|avenue|av\\.?|ave\\.?|boulevard|bd\\.?|blvd\\.?|boul|place|pl\\.?|square|sq\\.?|impasse|imp\\.?|'
		+ 'passage|pass\\.?|chemin|chem|ch\\.?|route|rt|rte\\.?|voie|allée|allee|all\\.?|quai|cours|'
		+ 'esplanade|parvis|villa|cité|residence|résidence|rés\\.?|lotissement|lot\\.?|lot|'
		+ 'hameau|faubourg|faub|fbg\\.?|mail|promenade|prom\\.?|sentier|traverse|'
		+ 'corniche|côte|cote|montée|montee|descente|rampe|escalier|galerie|'
		+ 'rond[\\-\\s]?point|carrefour|giratoire)';

	private static final Pattern NUMBER_THEN_STREET_PATTERN = Pattern.compile(
		'(?i)\\b(\\d+(?:-\\d+)?)\\s*(bis|ter|quater|quinquies|[a-zA-Z]{1,2})?(?:[\\s,]+(?:\\d{5}|[A-ZÉÈÊÀÂÎÔÛÇa-zéèêàâîôûç\\-]+)){0,3}?[\\s,]+'
		+ STREET_TYPES_PATTERN
		+ '\\b(.*)'
	);

	private static final Pattern STREET_THEN_NUMBER_PATTERN = Pattern.compile(
		'(?i)' + STREET_TYPES_PATTERN + '\\b(.*?)\\b(\\d+(?:-\\d+)?)\\s*(bis|ter|quater|quinquies|[a-zA-Z]{1,2})?\\b'
	);

	private static final Pattern STREET_ONLY_PATTERN = Pattern.compile(
		'(?i)' + STREET_TYPES_PATTERN + '\\b([^,]*?)(?:\\s*,.*)?$'
	);

	private static final PatternSpec NUMBER_LEADING_SPEC = new PatternSpec(NUMBER_THEN_STREET_PATTERN, 1, 2, 3, 4);
	private static final PatternSpec NUMBER_TRAILING_SPEC = new PatternSpec(STREET_THEN_NUMBER_PATTERN, 3, 4, 1, 2);
	private static final PatternSpec STREET_ONLY_SPEC = new PatternSpec(STREET_ONLY_PATTERN, null, null, 1, 2);

	global static ParseResult parseAddress(String addressText){
		if(String.isBlank(addressText))
			return new ParseResult(null, null);
		String cleaned = addressText.trim().replaceAll('\\s+', ' ');
		ParseResult case1Result = parseNumberLeading(cleaned);
		if(case1Result.hasData())
			return case1Result;
		ParseResult case2Result = parseNumberTrailing(cleaned);
		if(case2Result.hasData())
			return case2Result;
		return parseStreetWithoutNumber(cleaned);
	}

	private static ParseResult parseNumberLeading(String cleaned){
		return parseWithSpec(NUMBER_LEADING_SPEC, cleaned);
	}

	private static ParseResult parseNumberTrailing(String cleaned){
		return parseWithSpec(NUMBER_TRAILING_SPEC, cleaned);
	}

	private static ParseResult parseStreetWithoutNumber(String cleaned){
		return parseWithSpec(STREET_ONLY_SPEC, cleaned);
	}

	private static ParseResult parseWithSpec(PatternSpec spec, String cleaned){
		Matcher matcher = spec.pattern.matcher(cleaned);
		if(!matcher.find())
			return new ParseResult(null, null);
		String streetTypePart = spec.streetTypeIdx != null ? matcher.group(spec.streetTypeIdx) : '';
		String streetNamePart = spec.streetNameIdx != null ? matcher.group(spec.streetNameIdx) : '';
		String streetName = (streetTypePart == null ? '' : streetTypePart) + (streetNamePart != null ? streetNamePart : '');
		Integer commaIdx = streetName != null ? streetName.indexOf(',') : -1;
		if(commaIdx != null && commaIdx > -1)
			streetName = streetName.substring(0, commaIdx);
		streetName = String.isBlank(streetName) ? null : streetName.trim();
		return new ParseResult(
			formatNumber(spec.numberIdx != null ? matcher.group(spec.numberIdx) : null, spec.suffixIdx != null ? matcher.group(spec.suffixIdx) : null),
			streetName
		);
	}

	private static String formatNumber(String numberStr, String suffixStr){
		if(String.isBlank(numberStr))
			return null;
		if(String.isBlank(suffixStr))
			return numberStr;
		String trimmedSuffix = suffixStr.trim();
		String lowerSuffix = trimmedSuffix.toLowerCase();
		if(SUFFIX_MAP.containsKey(lowerSuffix))
			return numberStr + SUFFIX_MAP.get(lowerSuffix);
		return numberStr + trimmedSuffix;
	}

	global class ParseResult{
		global String streetNumber;
		global String streetName;

		global ParseResult(String streetNumber, String streetName){
			this.streetNumber = streetNumber;
			this.streetName = streetName;
		}

		global Boolean hasData(){
			return streetNumber != null || streetName != null;
		}
	}

	private class PatternSpec{
		private final Pattern pattern;
		private final Integer numberIdx;
		private final Integer suffixIdx;
		private final Integer streetTypeIdx;
		private final Integer streetNameIdx;

		private PatternSpec(Pattern pattern, Integer numberIdx, Integer suffixIdx, Integer streetTypeIdx, Integer streetNameIdx){
			this.pattern = pattern;
			this.numberIdx = numberIdx;
			this.suffixIdx = suffixIdx;
			this.streetTypeIdx = streetTypeIdx;
			this.streetNameIdx = streetNameIdx;
		}
	}
}