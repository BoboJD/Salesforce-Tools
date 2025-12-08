@IsTest
private class AddressUtilsTest{

	@IsTest
	static void parsesNumberLeadingAddresses(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('12B rue du Bac');
		Assert.equals('12bis', result.streetNumber);
		Assert.equals('rue du Bac', result.streetName);

		result = AddressUtils.parseAddress('8 ter avenue Victor Hugo');
		Assert.equals('8ter', result.streetNumber);
		Assert.equals('avenue Victor Hugo', result.streetName);

		result = AddressUtils.parseAddress('18 avenue de l\'Opéra, 75001 Paris');
		Assert.equals('18', result.streetNumber);
		Assert.equals('avenue de l\'Opéra', result.streetName);
	}

	@IsTest
	static void parsesNumberTrailingAddresses(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('avenue des Ternes 25');
		Assert.equals('25', result.streetNumber);
		Assert.equals('avenue des Ternes', result.streetName);

		result = AddressUtils.parseAddress('boulevard Haussmann 100q');
		Assert.equals('100quater', result.streetNumber);
		Assert.equals('boulevard Haussmann', result.streetName);

		result = AddressUtils.parseAddress('chemin du Lac 7, Lausanne');
		Assert.equals('7', result.streetNumber);
		Assert.equals('chemin du Lac', result.streetName);
	}

	@IsTest
	static void parsesStreetOnlyAddresses(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('place de l\'Étoile');
		Assert.isNull(result.streetNumber);
		Assert.equals('place de l\'Étoile', result.streetName);
	}

	@IsTest
	static void handlesEdgeCases(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress(null);
		Assert.isNull(result.streetNumber);
		Assert.isNull(result.streetName);

		result = AddressUtils.parseAddress('');
		Assert.isNull(result.streetNumber);
		Assert.isNull(result.streetName);

		result = AddressUtils.parseAddress('3-5 impasse des Lilas');
		Assert.equals('3-5', result.streetNumber);
		Assert.equals('impasse des Lilas', result.streetName);
	}

	@IsTest
	static void mapsKnownSuffixShortcuts(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('10b rue de la Liberté');
		Assert.equals('10bis', result.streetNumber);

		result = AddressUtils.parseAddress('20t avenue de la République');
		Assert.equals('20ter', result.streetNumber);

		result = AddressUtils.parseAddress('30q place du Marché');
		Assert.equals('30quater', result.streetNumber);
	}

	@IsTest
	static void keepsCasingForUnknownSuffix(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('40X chemin des Tests');
		Assert.equals('40X', result.streetNumber);
		Assert.equals('chemin des Tests', result.streetName);
	}

	@IsTest
	static void parsesAbbreviatedTypesWithDots(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('8 av. Victor Hugo');
		Assert.equals('8', result.streetNumber);
		Assert.equals('av. Victor Hugo', result.streetName);

		result = AddressUtils.parseAddress('15 bd. Saint-Michel');
		Assert.equals('15', result.streetNumber);
		Assert.equals('bd. Saint-Michel', result.streetName);
	}

	@IsTest
	static void parsesStreetOnlyAndStopsAtComma(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('rue des Fleurs, Paris');
		Assert.isNull(result.streetNumber);
		Assert.equals('rue des Fleurs', result.streetName);

		result = AddressUtils.parseAddress('bd. des Belges, Lyon');
		Assert.isNull(result.streetNumber);
		Assert.equals('bd. des Belges', result.streetName);
	}

	@IsTest
	static void acceptsUnaccentedVariants(){
		AddressUtils.ParseResult result = AddressUtils.parseAddress('12 cote des Neiges');
		Assert.equals('12', result.streetNumber);
		Assert.equals('cote des Neiges', result.streetName);
	}
}