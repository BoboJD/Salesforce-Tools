
import eslintPluginLwc from '@lwc/eslint-plugin-lwc';
import babelParser from '@babel/eslint-parser';
import globals from 'globals';

export default [
	{
		languageOptions: {
			ecmaVersion: 'latest',
			sourceType: 'module',
			globals: {
				...globals.browser,
				...globals.commonjs,
				...globals.es2021
			},
			parser: babelParser,
			parserOptions: {
				requireConfigFile: false,
				babelOptions: {
					parserOpts: {
						plugins: ['classProperties', ['decorators', { decoratorsBeforeExport: false }]]
					}
				}
			}
		},
		plugins: {
			lwc: eslintPluginLwc
		},
		rules: {
			'array-bracket-spacing': ['error', 'never'],
			'arrow-parens': ['error', 'as-needed'],
			'arrow-spacing': 'error',
			'brace-style': ['error', '1tbs', { 'allowSingleLine': true }],
			'comma-dangle': ['error', 'never'],
			'comma-style': ['error', 'last'],
			'computed-property-spacing': ['error', 'never'],
			'dot-location': ['error', 'property'],
			'eol-last': ['error', 'never'],
			'func-call-spacing': ['error', 'never'],
			'implicit-arrow-linebreak': ['error', 'beside'],
			'indent': ['error', 'tab'],
			'key-spacing': ['error', { 'beforeColon': false }],
			'new-parens': 'error',
			'no-confusing-arrow': 'error',
			'no-console': 'error',
			'no-extra-parens': ['error', 'all', { 'nestedBinaryExpressions': false, 'ternaryOperandBinaryExpressions': false }],
			'no-extra-semi': 'error',
			'no-floating-decimal': 'error',
			'no-mixed-operators': ['error', { 'groups': [['&', '|', '^', '~', '<<', '>>', '>>>'], ['&&', '||']] }],
			'no-mixed-spaces-and-tabs': 'error',
			'no-multi-spaces': 'error',
			'no-multiple-empty-lines': 'error',
			'no-trailing-spaces': 'error',
			'no-whitespace-before-property': 'error',
			'no-tabs': ['error', { allowIndentationTabs: true }],
			'object-curly-spacing': ['error', 'always'],
			'operator-linebreak': ['error', 'before'],
			'padded-blocks': ['error', { 'blocks': 'never' }],
			'quotes': ['error', 'single'],
			'rest-spread-spacing': ['error', 'never'],
			'semi': ['error', 'always'],
			'semi-spacing': 'error',
			'space-before-blocks': ['error', 'never'],
			'space-before-function-paren': ['error', 'never'],
			'space-in-parens': ['error', 'never'],
			'template-curly-spacing': ['error', 'never']
		}
	}
];