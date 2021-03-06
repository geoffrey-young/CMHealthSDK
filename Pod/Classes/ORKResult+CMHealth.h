#import <CloudMine/CMCoding.h>
#import <ResearchKit/ResearchKit.h>

typedef void(^CMHSaveCompletion)(NSString *_Nullable uploadStatus, NSError *_Nullable error);
typedef void(^CMHFetchCompletion)(NSArray *_Nullable results, NSError *_Nullable error);

@interface ORKResult (CMHealth)<CMCoding>

- (void)cmh_saveWithCompletion:(_Nullable CMHSaveCompletion)block;

- (void)cmh_saveToStudyWithDescriptor:(NSString *_Nullable)descriptor
                       withCompletion:(_Nullable CMHSaveCompletion)block;

+ (void)cmh_fetchUserResultsWithCompletion:(_Nullable CMHFetchCompletion)block;

+ (void)cmh_fetchUserResultsForStudyWithDescriptor:(NSString *_Nullable)descriptor
                                    withCompletion:(_Nullable CMHFetchCompletion)block;

+ (void)cmh_fetchUserResultsForStudyWithQuery:(NSString *_Nullable)query
                               withCompletion:(_Nullable CMHFetchCompletion)block;

+ (void)cmh_fetchUserResultsForStudyWithDescriptor:(NSString *_Nullable)descriptor
                                          andQuery:(NSString *_Nullable)query
                                    withCompletion:(_Nullable CMHFetchCompletion)block;
@end
