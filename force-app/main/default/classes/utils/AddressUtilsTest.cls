@IsTest
private class AddressUtilsTest{

	@IsTest
	static void parsesNumberLeadingAddresses(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('12B rue du Bac');
		System.assertEquals('12bis', result.streetNumber);
		System.assertEquals('rue du Bac', result.streetName);

		result = AddressUtils.parseAddress('8 ter avenue Victor Hugo');
		System.assertEquals('8ter', result.streetNumber);
		System.assertEquals('avenue Victor Hugo', result.streetName);

		result = AddressUtils.parseAddress('18 avenue de l\'Opéra, 75001 Paris');
		System.assertEquals('18', result.streetNumber);
		System.assertEquals('avenue de l\'Opéra', result.streetName);
	}

	@IsTest
	static void parsesNumberTrailingAddresses(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('avenue des Ternes 25');
		System.assertEquals('25', result.streetNumber);
		System.assertEquals('avenue des Ternes', result.streetName);

		result = AddressUtils.parseAddress('boulevard Haussmann 100q');
		System.assertEquals('100quater', result.streetNumber);
		System.assertEquals('boulevard Haussmann', result.streetName);

		result = AddressUtils.parseAddress('chemin du Lac 7, Lausanne');
		System.assertEquals('7', result.streetNumber);
		System.assertEquals('chemin du Lac', result.streetName);
	}

	@IsTest
	static void parsesStreetOnlyAddresses(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('place de l\'Étoile');
		System.assertEquals(null, result.streetNumber);
		System.assertEquals('place de l\'Étoile', result.streetName);
	}

	@IsTest
	static void handlesEdgeCases(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress(null);
		System.assertEquals(null, result.streetNumber);
		System.assertEquals(null, result.streetName);

		result = AddressUtils.parseAddress('');
		System.assertEquals(null, result.streetNumber);
		System.assertEquals(null, result.streetName);

		result = AddressUtils.parseAddress('3-5 impasse des Lilas');
		System.assertEquals('3-5', result.streetNumber);
		System.assertEquals('impasse des Lilas', result.streetName);
	}

	@IsTest
	static void mapsKnownSuffixShortcuts(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('10b rue de la Liberté');
		System.assertEquals('10bis', result.streetNumber);

		result = AddressUtils.parseAddress('20t avenue de la République');
		System.assertEquals('20ter', result.streetNumber);

		result = AddressUtils.parseAddress('30q place du Marché');
		System.assertEquals('30quater', result.streetNumber);
	}

	@IsTest
	static void keepsCasingForUnknownSuffix(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('40X chemin des Tests');
		System.assertEquals('40X', result.streetNumber);
		System.assertEquals('chemin des Tests', result.streetName);
	}

	@IsTest
	static void parsesAbbreviatedTypesWithDots(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('8 av. Victor Hugo');
		System.assertEquals('8', result.streetNumber);
		System.assertEquals('av. Victor Hugo', result.streetName);

		result = AddressUtils.parseAddress('15 bd. Saint-Michel');
		System.assertEquals('15', result.streetNumber);
		System.assertEquals('bd. Saint-Michel', result.streetName);
	}

	@IsTest
	static void parsesStreetOnlyAndStopsAtComma(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('rue des Fleurs, Paris');
		System.assertEquals(null, result.streetNumber);
		System.assertEquals('rue des Fleurs', result.streetName);

		result = AddressUtils.parseAddress('bd. des Belges, Lyon');
		System.assertEquals(null, result.streetNumber);
		System.assertEquals('bd. des Belges', result.streetName);
	}

	@IsTest
	static void acceptsUnaccentedVariants(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('12 cote des Neiges');
		System.assertEquals('12', result.streetNumber);
		System.assertEquals('cote des Neiges', result.streetName);
	}
}