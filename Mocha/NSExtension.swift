import Foundation

/* TODO: Add a Swift interface for the following NSExtension API. */

/*
@interface NSExtension : NSObject

// Match or find all extensions fitting the given attributes.
// Attributes example: @{ @"NSExtensionPointName" : @"com.apple.services" };
+ (id)beginMatchingExtensionsWithAttributes:(NSDictionary *)attributes completion:(void (^)(NSArray *matchingExtensions, NSError *error))block;
+ (void)endMatchingExtensions:(id)request;
+ (void)extensionsWithMatchingAttributes:(NSDictionary *)attributes completion:(void (^)(NSArray *matchingExtensions, NSError *error))block;
 
// Create an extension with the identifier given.
+ (instancetype)extensionWithIdentifier:(NSString *)identifier error:(NSError **)error;

// Begin a request with an array of NSExtensionItems. The UUID returned identifies requests.
- (void)beginExtensionRequestWithInputItems:(NSArray *)inputItems completion:(void (^)(NSUUID *requestIdentifier))completion;

- (int)pidForRequestIdentifier:(NSUUID *)requestIdentifier;
- (void)cancelExtensionRequestWithIdentifier:(NSUUID *)requestIdentifier;

// This block will be called if the extension calls [context cancelRequestWithError:]
- (void)setRequestCancellationBlock:(void (^)(NSUUID *uuid, NSError *error))cancellationBlock;

// This block will be called if the extension calls [context completeRequestReturningItems:completionHandler:]
- (void)setRequestCompletionBlock:(void (^)(NSUUID *uuid, NSArray *extensionItems))completionBlock;

// This block will be called if the extension process crashes or there was an XPC communication issue.
- (void)setRequestInterruptionBlock:(void (^)(NSUUID *uuid))interruptionBlock;

@end
*/
