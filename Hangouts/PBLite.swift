import Foundation
import CommonCrypto

/* TODO: Remove dependency on CommonCrypto. */

// PBLiteSerialization wrapper

public class PBLiteSerialization {
	
	/* TODO: Use Swift reflection to unwrap AnyObject?. */
	public class func _unwrapOptionalType(any: Any) -> Any.Type? {
		let dynamicTypeName = "\(Mirror(reflecting: any).subjectType)"
		if dynamicTypeName.contains("Optional<") {
			var containedTypeName = dynamicTypeName.replacingOccurrences(of: "Optional<", with: "")
			containedTypeName = containedTypeName.replacingOccurrences(of: ">", with: "")
			return NSClassFromString(containedTypeName)
		}
		return nil
	}
	
	/* TODO: Use Swift reflection to unwrap [AnyObject]?. */
	public class func _unwrapOptionalArrayType(any: Any) -> Any.Type? {
		let dynamicTypeName = "\(Mirror(reflecting: any).subjectType)"
		
		if dynamicTypeName.contains("Swift.Array") {
			print("Encountered Swift.Array -> \(dynamicTypeName)!")
		}
		
		if dynamicTypeName.contains("Optional<Array") {
			var containedTypeName = dynamicTypeName.replacingOccurrences(of: "Optional<", with: "")
			containedTypeName = containedTypeName.replacingOccurrences(of: "Swift.Array<", with: "")
			containedTypeName = containedTypeName.replacingOccurrences(of: "Array<", with: "")
			containedTypeName = containedTypeName.replacingOccurrences(of: ">", with: "")
			return NSClassFromString(containedTypeName)
		}
		return nil
	}
	
	/* TODO: Use Swift reflection to unwrap [AnyObject]. */
	/* TODO: Add all Message classes here. */
	//return Mirror(reflecting: arr).types[0] as! Message.Type
	public class func getArrayMessageType(arr: Any) -> Message.Type? {
		if arr is [ConversationId] { return ConversationId.self }
		if arr is [ConversationState] { return ConversationState.self }
		if arr is [ParticipantId] { return ParticipantId.self }
		if arr is [EVENT] { return EVENT.self }
		if arr is [Entity] { return Entity.self }
		if arr is [MessageSegment] { return MessageSegment.self }
		if arr is [MessageAttachment] { return MessageAttachment.self }
		if arr is [ConversationParticipantData] { return ConversationParticipantData.self }
		if arr is [ConversationReadState] { return ConversationReadState.self }
		if arr is [EntityGroupEntity] { return EntityGroupEntity.self }
		if arr is [ParticipantId] { return ParticipantId.self }
		if arr is [Thumbnail] { return Thumbnail.self }
		if arr is [PlusPhoto] { return PlusPhoto.self }
		if arr is [RepresentativeImage] { return RepresentativeImage.self }
		if arr is [Place] { return Place.self }
		if arr is [EmbedItem] { return EmbedItem.self }
		if arr is [EventAnnotation] { return EventAnnotation.self }
		if arr is [ChatMessage] { return ChatMessage.self }
		if arr is [MembershipChange] { return MembershipChange.self }
		if arr is [ConversationRename] { return ConversationRename.self }
		if arr is [HANGOUT_EVENT] { return HANGOUT_EVENT.self }
		if arr is [OTRModification] { return OTRModification.self }
		if arr is [HashModifier] { return HashModifier.self }
		if arr is [EVENT] { return EVENT.self }
		if arr is [UserReadState] { return UserReadState.self }
		if arr is [DeliveryMedium] { return DeliveryMedium.self }
		if arr is [DeliveryMediumOption] { return DeliveryMediumOption.self }
		if arr is [UserConversationState] { return UserConversationState.self }
		if arr is [ConversationParticipantData] { return ConversationParticipantData.self }
		if arr is [CONVERSATION] { return CONVERSATION.self }
		if arr is [EasterEgg] { return EasterEgg.self }
		if arr is [BlockStateChange] { return BlockStateChange.self }
		if arr is [Photo] { return Photo.self }
		if arr is [ExistingMedia] { return ExistingMedia.self }
		if arr is [EventRequestHeader] { return EventRequestHeader.self }
		if arr is [ClientVersion] { return ClientVersion.self }
		if arr is [RequestHeader] { return RequestHeader.self }
		if arr is [Entity] { return Entity.self }
		if arr is [EntityProperties] { return EntityProperties.self }
		if arr is [ConversationState] { return ConversationState.self }
		if arr is [EventContinuationToken] { return EventContinuationToken.self }
		if arr is [EntityLookupSpec] { return EntityLookupSpec.self }
		if arr is [RichPresenceState] { return RichPresenceState.self }
		if arr is [RichPresenceEnabledState] { return RichPresenceEnabledState.self }
		if arr is [DesktopOffSetting] { return DesktopOffSetting.self }
		if arr is [DesktopOffState] { return DesktopOffState.self }
		if arr is [DndSetting] { return DndSetting.self }
		if arr is [PresenceStateSetting] { return PresenceStateSetting.self }
		if arr is [MoodMessage] { return MoodMessage.self }
		if arr is [MoodContent] { return MoodContent.self }
		if arr is [MoodSetting] { return MoodSetting.self }
		if arr is [MoodState] { return MoodState.self }
		if arr is [DeleteAction] { return DeleteAction.self }
		if arr is [InviteeID] { return InviteeID.self }
		if arr is [Country] { return Country.self }
		if arr is [DesktopSoundSetting] { return DesktopSoundSetting.self }
		if arr is [PhoneData] { return PhoneData.self }
		if arr is [Phone] { return Phone.self }
		if arr is [I18nData] { return I18nData.self }
		if arr is [PhoneNumber] { return PhoneNumber.self }
		if arr is [SuggestedContactGroupHash] { return SuggestedContactGroupHash.self }
		if arr is [SuggestedContact] { return SuggestedContact.self }
		if arr is [SuggestedContactGroup] { return SuggestedContactGroup.self }
		if arr is [StateUpdateHeader] { return StateUpdateHeader.self }
		if arr is [BatchUpdate] { return BatchUpdate.self }
		if arr is [EventNotification] { return EventNotification.self }
		if arr is [SetFocusNotification] { return SetFocusNotification.self }
		if arr is [SetTypingNotification] { return SetTypingNotification.self }
		if arr is [SetConversationNotificationLevelNotification] { return SetConversationNotificationLevelNotification.self }
		if arr is [ReplyToInviteNotification] { return ReplyToInviteNotification.self }
		if arr is [ConversationViewModification] { return ConversationViewModification.self }
		if arr is [EasterEggNotification] { return EasterEggNotification.self }
		if arr is [SelfPresenceNotification] { return SelfPresenceNotification.self }
		if arr is [DeleteActionNotification] { return DeleteActionNotification.self }
		if arr is [PresenceNotification] { return PresenceNotification.self }
		if arr is [BlockNotification] { return BlockNotification.self }
		if arr is [SetNotificationSettingNotification] { return SetNotificationSettingNotification.self }
		if arr is [RichPresenceEnabledStateNotification] { return RichPresenceEnabledStateNotification.self }
		if arr is [ConversationSpec] { return ConversationSpec.self }
		if arr is [AddUserRequest] { return AddUserRequest.self }
		if arr is [AddUserResponse] { return AddUserResponse.self }
		if arr is [CreateConversationRequest] { return CreateConversationRequest.self }
		if arr is [CreateConversationResponse] { return CreateConversationResponse.self }
		if arr is [DeleteConversationRequest] { return DeleteConversationRequest.self }
		if arr is [DeleteConversationResponse] { return DeleteConversationResponse.self }
		if arr is [EasterEggRequest] { return EasterEggRequest.self }
		if arr is [EasterEggResponse] { return EasterEggResponse.self }
		if arr is [GetConversationRequest] { return GetConversationRequest.self }
		if arr is [GetConversationResponse] { return GetConversationResponse.self }
		if arr is [GetEntityByIdRequest] { return GetEntityByIdRequest.self }
		if arr is [GetEntityByIdResponse] { return GetEntityByIdResponse.self }
		if arr is [GetSuggestedEntitiesRequest] { return GetSuggestedEntitiesRequest.self }
		if arr is [GetSuggestedEntitiesResponse] { return GetSuggestedEntitiesResponse.self }
		if arr is [GetSelfInfoRequest] { return GetSelfInfoRequest.self }
		if arr is [QueryPresenceRequest] { return QueryPresenceRequest.self }
		if arr is [QueryPresenceResponse] { return QueryPresenceResponse.self }
		if arr is [RemoveUserRequest] { return RemoveUserRequest.self }
		if arr is [RemoveUserResponse] { return RemoveUserResponse.self }
		if arr is [RenameConversationRequest] { return RenameConversationRequest.self }
		if arr is [RenameConversationResponse] { return RenameConversationResponse.self }
		if arr is [SearchEntitiesRequest] { return SearchEntitiesRequest.self }
		if arr is [SearchEntitiesResponse] { return SearchEntitiesResponse.self }
		if arr is [SendChatMessageRequest] { return SendChatMessageRequest.self }
		if arr is [SendChatMessageResponse] { return SendChatMessageResponse.self }
		if arr is [SetActiveClientRequest] { return SetActiveClientRequest.self }
		if arr is [SetActiveClientResponse] { return SetActiveClientResponse.self }
		if arr is [SetConversationLevelRequest] { return SetConversationLevelRequest.self }
		if arr is [SetConversationLevelResponse] { return SetConversationLevelResponse.self }
		if arr is [SetConversationNotificationLevelRequest] { return SetConversationNotificationLevelRequest.self }
		if arr is [SetConversationNotificationLevelResponse] { return SetConversationNotificationLevelResponse.self }
		if arr is [SetFocusRequest] { return SetFocusRequest.self }
		if arr is [SetFocusResponse] { return SetFocusResponse.self }
		if arr is [SetPresenceRequest] { return SetPresenceRequest.self }
		if arr is [SetPresenceResponse] { return SetPresenceResponse.self }
		if arr is [SetTypingRequest] { return SetTypingRequest.self }
		if arr is [SetTypingResponse] { return SetTypingResponse.self }
		if arr is [SyncAllNewEventsRequest] { return SyncAllNewEventsRequest.self }
		if arr is [SyncAllNewEventsResponse] { return SyncAllNewEventsResponse.self }
		if arr is [SyncRecentConversationsRequest] { return SyncRecentConversationsRequest.self }
		if arr is [SyncRecentConversationsResponse] { return SyncRecentConversationsResponse.self }
		if arr is [UpdateWatermarkRequest] { return UpdateWatermarkRequest.self }
		if arr is [UpdateWatermarkResponse] { return UpdateWatermarkResponse.self }
		return nil
	}
	
	/* TODO: Use Swift reflection to unwrap [AnyObject]. */
	public class func getArrayEnumType(arr: Any) -> Enum.Type? {
		if arr is [ActiveClientState] { return ConversationView.self }
		if arr is [FocusType] { return FocusType.self }
		if arr is [FocusDevice] { return FocusDevice.self }
		if arr is [TypingType] { return TypingType.self }
		if arr is [ClientPresenceStateType] { return ClientPresenceStateType.self }
		if arr is [NotificationLevel] { return NotificationLevel.self }
		if arr is [SegmentType] { return SegmentType.self }
		if arr is [ItemType] { return ItemType.self }
		if arr is [MediaType] { return MediaType.self }
		if arr is [MembershipChangeType] { return MembershipChangeType.self }
		if arr is [HangoutEventType] { return HangoutEventType.self }
		if arr is [OffTheRecordToggle] { return OffTheRecordToggle.self }
		if arr is [OffTheRecordStatus] { return OffTheRecordStatus.self }
		if arr is [SourceType] { return SourceType.self }
		if arr is [EventType] { return EventType.self }
		if arr is [ConversationType] { return ConversationType.self }
		if arr is [ConversationStatus] { return ConversationStatus.self }
		if arr is [ConversationView] { return ConversationView.self }
		if arr is [DeliveryMediumType] { return DeliveryMediumType.self }
		if arr is [ParticipantType] { return ParticipantType.self }
		if arr is [InvitationStatus] { return InvitationStatus.self }
		if arr is [ForceHistory] { return ForceHistory.self }
		if arr is [NetworkType] { return NetworkType.self }
		if arr is [BlockState] { return BlockState.self }
		if arr is [ReplyToInviteType] { return ReplyToInviteType.self }
		if arr is [ClientID] { return ClientID.self }
		if arr is [ClientBuildType] { return ClientBuildType.self }
		if arr is [ResponseStatus] { return ResponseStatus.self }
		if arr is [PastHangoutState] { return PastHangoutState.self }
		if arr is [PhotoURLStatus] { return PhotoURLStatus.self }
		if arr is [Gender] { return Gender.self }
		if arr is [ProfileType] { return ProfileType.self }
		if arr is [ConfigurationBitType] { return ConfigurationBitType.self }
		if arr is [RichPresenceType] { return RichPresenceType.self }
		if arr is [FieldMask] { return FieldMask.self }
		if arr is [DeleteType] { return DeleteType.self }
		if arr is [SyncFilter] { return SyncFilter.self }
		if arr is [SoundState] { return SoundState.self }
		if arr is [CallerIDSettingsMask] { return CallerIDSettingsMask.self }
		if arr is [PhoneVerificationStatus] { return PhoneVerificationStatus.self }
		if arr is [PhoneDiscoverabilityStatus] { return PhoneDiscoverabilityStatus.self }
		if arr is [PhoneValidationResult] { return PhoneValidationResult.self }
		return nil
	}
	
	/* TODO: Use Swift reflection to unwrap. */
	public class func valueWithTypeCoercion(property: Any, value: AnyObject?) -> AnyObject? {
		if property is NSDate || _unwrapOptionalType(any: property) is NSDate.Type {
			if let number = value as? NSNumber {
				let timestampAsDate = from_timestamp(microsecond_timestamp: number)
				return timestampAsDate
			}
		}
		return value
	}
	
	public class func parseProtoJSON<T: Message>(input: NSData) -> T? {
		let script = (NSString(data: input, encoding: NSUTF8StringEncoding)! as String)
		if let parsedObject = evalArray(string: script) as? NSArray {
			return parseArray(type: T.self, input: parsedObject)
		}
		return nil
	}
	
	// Parsing
	
	public class func parseArray<T: Message>(type: T.Type, input: NSArray?) -> T? {
		guard let arr = input else {
			return nil // expected array
		}
		
		let instance = type.init()
		let reflection = Mirror(reflecting: instance)
		let children = Array(reflection.children)
		for i in 0..<min(arr.count, children.count) {
			let propertyName = children[i].label!
			let property = children[i].value
			
			//  Unwrapping an optional sub-struct
			if let type = _unwrapOptionalType(any: property) as? Message.Type {
				let val: (AnyObject?) = parseArray(type: type, input: arr[i] as? NSArray)
				instance.setValue(val, forKey: propertyName)
				
				//  Using a non-optional sub-struct
			} else if let message = property as? Message {
				let val: (AnyObject?) = parseArray(type: message.dynamicType, input: arr[i] as? NSArray)
				instance.setValue(val, forKey: propertyName)
				
				//  Unwrapping an optional enum
			} else if let type = _unwrapOptionalType(any: property) as? Enum.Type {
				var val: AnyObject?
				/* TODO: Support NSNull literal conversion. */
				if arr[i] as? NSNumber == nil {
					val = type.init(value: 0)
				} else {
					val = type.init(value: (arr[i] as! NSNumber))
				}
				instance.setValue(val, forKey: propertyName)
				
				//  Using a non-optional sub-struct
			} else if let enumv = property as? Enum {
				var val: AnyObject?
				/* TODO: Support NSNull literal conversion. */
				if arr[i] as? NSNumber == nil {
					val = enumv.dynamicType.init(value: 0)
				} else {
					val = enumv.dynamicType.init(value: (arr[i] as! NSNumber))
				}
				instance.setValue(val, forKey: propertyName)
				
				// Default
			} else {
				if arr[i] is NSNull {
					instance.setValue(nil, forKey: propertyName)
				} else {
					if let elementType = _unwrapOptionalArrayType(any: property) {
						let elementMessageType = elementType as! T.Type
						let val = (arr[i] as! NSArray).map {
							parseArray(type: elementMessageType, input: $0 as? NSArray)
						}.filter { $0 != nil }.map { $0! }
						print(val)
						instance.setValue(val, forKey:propertyName)
					} else if let elementType = getArrayMessageType(arr: property) {
						let val = (arr[i] as! NSArray).map {
							parseArray(type: elementType, input: $0 as? NSArray)
						}.filter { $0 != nil }.map { $0! }
						print(val)
						instance.setValue(val, forKey:propertyName)
					} else if let elementType = getArrayEnumType(arr: property) {
						let val = (arr[i] as! NSArray).map {
							elementType.init(value: ($0 as! NSNumber))
						}
						instance.setValue(val, forKey:propertyName)
					} else {
						instance.setValue(valueWithTypeCoercion(property: property, value: arr[i]), forKey:propertyName)
					}
				}
			}
		}
		return instance
	}
	
	public class func parseDictionary<T: Message>(type: T.Type, obj: NSDictionary) -> T? {
		let instance = type.init()
		let reflection = Mirror(reflecting: instance)
		for child in reflection.children {
			let propertyName = child.label!
			let property = child.value
			
			let value: AnyObject? = obj[propertyName]
			
			//  Unwrapping an optional sub-struct
			if let type = _unwrapOptionalType(any: property) as? Message.Type {
				let val: (AnyObject?) = parseDictionary(type: type, obj: value as! NSDictionary)
				instance.setValue(val, forKey: propertyName)
				
				//  Using a non-optional sub-struct
			} else if let message = property as? Message {
				let val: (AnyObject?) = parseDictionary(type: message.dynamicType, obj: value as! NSDictionary)
				instance.setValue(val, forKey: propertyName)
				
				//  Unwrapping an optional enum
			} else if let type = _unwrapOptionalType(any: property) as? Enum.Type {
				let val: (AnyObject?) = type.init(value: (value as! NSNumber))
				instance.setValue(val, forKey: propertyName)
				
				//  Using a non-optional sub-struct
			} else if let enumv = property as? Enum {
				let val: (AnyObject?) = enumv.dynamicType.init(value: (value as! NSNumber))
				instance.setValue(val, forKey: propertyName)
				
				// Default
			} else {
				if value is NSNull || value == nil {
					instance.setValue(nil, forKey: propertyName)
				} else {
					if let elementType = getArrayMessageType(arr: property) {
						let val = (value as! NSArray).map {
							parseDictionary(type: elementType, obj: $0 as! NSDictionary)!
						}
						instance.setValue(val, forKey:propertyName)
					} else if let elementType = getArrayEnumType(arr: property) {
						let val = (value as! NSArray).map {
							elementType.init(value: ($0 as! NSNumber))
						}
						instance.setValue(val, forKey:propertyName)
					} else {
						instance.setValue(valueWithTypeCoercion(property: property, value: value), forKey: propertyName)
					}
				}
			}
		}
		return instance
	}
}

//
// TRANSLATION CODE
//

extension String {
	func substring(between start: String, and to: String) -> String? {
		return (range(of: start)?.upperBound).flatMap { startIdx in
			(range(of: to, range: startIdx..<endIndex)?.lowerBound).map { endIdx in
				substring(with: startIdx..<endIdx)
			}
		}
	}
}

// @unused: Only used in compiling proto files to Swift!
func _translateProtoToSwift(str: String) -> String {
	let title = str.substring(between: "message ", and: " {")!
	var scanned = 1
	let b = str.substring(between: "{", and: "}")?
		.components(separatedBy: ";")
		.map {
			$0.trimmingCharacters(in: .whitespacesAndNewlines())
		}.filter {
			!$0.isEmpty
		}.map {
			$0.components(separatedBy: " ").filter { $0 != "=" }
		}.map { a -> String in
			var modifier = a[0], type = a[1], name = a[2], id = Int(a[3])!
			
			switch type {
			case "string", "bytes": type = "NSString"
			case "double", "float", "int32", "int64", "uint32",
				 "uint64", "sint32", "sint64", "fixed32", "fixed64",
				 "sfixed32", "sfixed64", "bool": type = "NSNumber"
			default: break
			}
			
			var filler = ""
			for r in (scanned..<id).dropFirst() {
				filler += "public var field\(r): AnyObject?\n\t"
			}
			scanned = Int(a[3])!
			
			switch modifier {
			case "optional":
				return filler + "public var \(name): \(type)?"
			case "required":
				return filler + "public var \(name) = \(type)()"
			case "repeated":
				return filler + "public var \(name) = [\(type)]()"
			default: return ""
			}
		}
	let body = b!.reduce("") { $0 + "\n\t" + $1 }
	
	let TEMPLATE = "@objc(%NAME%)\npublic class %NAME%: Message {%BODY%\n}"
	let tmp = TEMPLATE.replacingOccurrences(of: "%NAME%", with: title)
	return tmp.replacingOccurrences(of: "%BODY%", with: body)
}
func _translateAllProtoToSwift(str: String) -> String {
	return str.components(separatedBy: "}\n").map { $0 + "}\n" }
		.map(_translateProtoToSwift).reduce("") { $0 + "\n\n" + $1 }
}



//
// BIG CRUTCH: Should be replaced later.
//

import JavaScriptCore
@available(iOS, deprecated: 1.0, message: "Avoid JSContext!")
@available(OSX, deprecated: 1.0, message: "Avoid JSContext!")
public func evalArray(string: String) -> AnyObject? {
	return JSContext().evaluateScript("a = " + string).toArray()
}
public func evalDict(string: String) -> AnyObject? {
	return JSContext().evaluateScript("a = " + string).toDictionary()
}


//
// SHOEHORNED HERE
//


public let ORIGIN_URL = "https://talkgadget.google.com"
// Return authorization headers for API request. It doesn't seem to matter
// what the url and time are as long as they are consistent.
public func getAuthorizationHeaders(sapisid_cookie: String) -> Dictionary<String, String> {
	let time_msec = Int(NSDate().timeIntervalSince1970 * 1000)
	let auth_string = "\(time_msec) \(sapisid_cookie) \(ORIGIN_URL)"
	let auth_hash = auth_string.SHA1()
	let sapisidhash = "SAPISIDHASH \(time_msec)_\(auth_hash)"
	return [
		"Authorization": sapisidhash,
		"X-Origin": ORIGIN_URL,
		"X-Goog-Authuser": "0",
	]
}

/* String Crypto extensions */
public extension String {
	public func SHA1() -> String {
		let data = self.data(using: NSUTF8StringEncoding)!
		var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
		CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
		let hexBytes = digest.map {
			String(format: "%02hhx", $0)
		}
		return hexBytes.joined(separator: "")
	}
}
