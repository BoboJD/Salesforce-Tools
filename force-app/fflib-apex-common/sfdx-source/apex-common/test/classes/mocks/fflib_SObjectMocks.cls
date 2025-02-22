/**
 * Copyright (c), FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/* Generated by apex-mocks-generator version 4.0.0 */
@isTest
global class fflib_SObjectMocks
{
	global virtual class SObjectDomain implements fflib_ISObjectDomain
	{
		private fflib_ApexMocks mocks;

		global SObjectDomain(fflib_ApexMocks mocks)
		{
			this.mocks = mocks;
		}

		global Schema.SObjectType sObjectType()
		{
			return (Schema.SObjectType) mocks.mockNonVoidMethod(this, 'sObjectType', new List<Type> {}, new List<Object> {});
		}

		global List<SObject> getRecords()
		{
			return (List<SObject>) mocks.mockNonVoidMethod(this, 'getRecords', new List<Type> {}, new List<Object> {});
		}

		global Object getType()
		{
			return sObjectType();
		}

		global List<Object> getObjects()
		{
			return getRecords();
		}
	}

	global virtual class SObjectSelector implements fflib_ISObjectSelector
	{
		private fflib_ApexMocks mocks;

		global SObjectSelector(fflib_ApexMocks mocks)
		{
			this.mocks = mocks;
		}

		global Schema.SObjectType sObjectType()
		{
			return (Schema.SObjectType) mocks.mockNonVoidMethod(this, 'sObjectType', new List<Type> {}, new List<Object> {});
		}

		global List<SObject> selectSObjectsById(Set<Id> idSet)
		{
			return (List<SObject>) mocks.mockNonVoidMethod(this, 'selectSObjectsById', new List<Type> {Set<Id>.class}, new List<Object> {idSet});
		}
	}

	global virtual class SObjectUnitOfWork implements fflib_ISObjectUnitOfWork
	{
		private fflib_ApexMocks mocks;

		global SObjectUnitOfWork(fflib_ApexMocks mocks)
		{
			this.mocks = mocks;
		}

		global void registerNew(SObject record)
		{
			mocks.mockVoidMethod(this, 'registerNew', new List<Type> {SObject.class}, new List<Object> {record});
		}

		global void registerNew(List<SObject> records)
		{
			mocks.mockVoidMethod(this, 'registerNew', new List<Type> {List<SObject>.class}, new List<Object> {records});
		}

		global void registerNew(SObject record, Schema.sObjectField relatedToParentField, SObject relatedToParentRecord)
		{
			mocks.mockVoidMethod(this, 'registerNew', new List<Type> {SObject.class, Schema.sObjectField.class, SObject.class}, new List<Object> {record, relatedToParentField, relatedToParentRecord});
		}

		global void registerRelationship(SObject record, Schema.sObjectField relatedToField, SObject relatedTo)
		{
			mocks.mockVoidMethod(this, 'registerRelationship', new List<Type> {SObject.class, Schema.sObjectField.class, SObject.class}, new List<Object> {record, relatedToField, relatedTo});
		}

		global void registerRelationship(Messaging.SingleEmailMessage email, SObject relatedTo)
		{
			mocks.mockVoidMethod(this, 'registerRelationship', new List<Type> {Messaging.SingleEmailMessage.class, SObject.class}, new List<Object> {email, relatedTo});
		}

        global void registerRelationship(SObject record, Schema.sObjectField relatedToField, Schema.sObjectField externalIdField, Object externalId)
        {
            mocks.mockVoidMethod(this, 'registerRelationship', new List<Type> {SObject.class, Schema.sObjectField.class, Schema.sObjectField.class, Object.class}, new List<Object> {record, relatedToField, externalIdField, externalId});
		}

		global void registerDirty(SObject record)
		{
			mocks.mockVoidMethod(this, 'registerDirty', new List<Type> {SObject.class}, new List<Object> {record});
		}

		global void registerDirty(List<SObject> records, List<SObjectField> dirtyFields)
		{
			mocks.mockVoidMethod(this, 'registerDirty', new List<Type> {
					SObject.class, System.Type.forName('List<SObjectField>')
			}, new List<Object> {
					records, dirtyFields
			});
		}

		global void registerDirty(SObject record, List<SObjectField> dirtyFields)
		{
			mocks.mockVoidMethod(this, 'registerDirty', new List<Type> {
					SObject.class, System.Type.forName('List<SObjectField>')
			}, new List<Object> {
					record, dirtyFields
			});
		}

        global void registerDirty(SObject record, Schema.sObjectField relatedToParentField, SObject relatedToParentRecord)
        {
            mocks.mockVoidMethod(this, 'registerDirty', new List<Type> {
				SObject.class, SObjectField.class, SObject.class
			}, new List<Object>{
				record, relatedToParentField, relatedToParentRecord
			});
        }

		global void registerDirty(List<SObject> records)
		{
			mocks.mockVoidMethod(this, 'registerDirty', new List<Type> {List<SObject>.class}, new List<Object> {records});
		}

		global void registerUpsert(SObject record)
		{
			mocks.mockVoidMethod(this, 'registerUpsert', new List<Type> {List<SObject>.class}, new List<Object> {record});
		}

		global void registerEmptyRecycleBin(SObject record)
		{
			mocks.mockVoidMethod(this, 'registerEmptyRecycleBin', new List<Type> {List<SObject>.class}, new List<Object> {record});
		}

		global void registerEmptyRecycleBin(List<SObject> records)
		{
			mocks.mockVoidMethod(this, 'registerEmptyRecycleBin', new List<Type> {List<SObject>.class}, new List<Object> {records});
		}

		global void registerUpsert(List<SObject> records)
		{
			mocks.mockVoidMethod(this, 'registerUpsert', new List<Type> {List<SObject>.class}, new List<Object> {records});
		}

		global void registerDeleted(SObject record)
		{
			mocks.mockVoidMethod(this, 'registerDeleted', new List<Type> {SObject.class}, new List<Object> {record});
		}

		global void registerDeleted(List<SObject> records)
		{
			mocks.mockVoidMethod(this, 'registerDeleted', new List<Type> {List<SObject>.class}, new List<Object> {records});
		}

		global void registerPermanentlyDeleted(SObject record)
		{
			mocks.mockVoidMethod(this, 'registerPermanentlyDeleted', new List<Type> {SObject.class}, new List<Object> {record});
		}

		global void registerPermanentlyDeleted(List<SObject> records)
		{
			mocks.mockVoidMethod(this, 'registerPermanentlyDeleted', new List<Type> {SObject.class}, new List<Object> {records});
		}

		global void registerPublishBeforeTransaction(SObject record)
		{
			mocks.mockVoidMethod(this, 'registerPublishBeforeTransaction', new List<Type> {SObject.class}, new List<Object> {record});
		}

		global void registerPublishBeforeTransaction(List<SObject> records)
		{
			mocks.mockVoidMethod(this, 'registerPublishBeforeTransaction', new List<Type> {List<SObject>.class}, new List<Object> {records});
		}

		global void registerPublishAfterSuccessTransaction(SObject record)
		{
			mocks.mockVoidMethod(this, 'registerPublishAfterSuccessTransaction', new List<Type> {SObject.class}, new List<Object> {record});
		}
		global void registerPublishAfterSuccessTransaction(List<SObject> records)
		{
			mocks.mockVoidMethod(this, 'registerPublishAfterSuccessTransaction', new List<Type> {List<SObject>.class}, new List<Object> {records});
		}
		global void registerPublishAfterFailureTransaction(SObject record)
		{
			mocks.mockVoidMethod(this, 'registerPublishAfterFailureTransaction', new List<Type> {SObject.class}, new List<Object> {record});
		}
		global void registerPublishAfterFailureTransaction(List<SObject> records)
		{
			mocks.mockVoidMethod(this, 'registerPublishAfterFailureTransaction', new List<Type> {List<SObject>.class}, new List<Object> {records});
		}


	global void commitWork()
	{
		mocks.mockVoidMethod(this, 'commitWork', new List<Type> {}, new List<Object> {});
	}

	global void registerWork(fflib_SObjectUnitOfWork.IDoWork work)
	{
		mocks.mockVoidMethod(this, 'registerWork', new List<Type> {fflib_SObjectUnitOfWork.IDoWork.class}, new List<Object> {work});
	}

	global void registerEmail(Messaging.Email email)
	{
		mocks.mockVoidMethod(this, 'registerEmail', new List<Type> {Messaging.Email.class}, new List<Object> {email});
	}
	}

}