//
//  ADModelsHelpers.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/7/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#ifndef South_Worcestershire_ModelsHelpers_h
#define South_Worcestershire_ModelsHelpers_h

#define GET_CACHED_VALUE_WRAP(TYPE, GETTER, DOMAIN_OBJECT, DOMAIN_GETTER, WRAPPER)                \
    -(TYPE)GETTER                                                                                 \
    {                                                                                             \
        if (!_##GETTER) {                                                                         \
            if ([DOMAIN_OBJECT DOMAIN_GETTER]) {                                                  \
                _##GETTER = [[WRAPPER alloc] initWithDomainObject:[DOMAIN_OBJECT DOMAIN_GETTER]]; \
            }                                                                                     \
        }                                                                                         \
        return _##GETTER;                                                                         \
    }

typedef NSArray * (^dls_array_mapper_block)(NSArray *objects);
typedef id (^dls_each_mapper_block)(id element);

#define GET_MAPPED_VALUE(TYPE, GETTER, DOMAIN_OBJECT, DOMAIN_GETTER) \
    -(TYPE)GETTER                                                    \
    {                                                                \
        return [DOMAIN_OBJECT DOMAIN_GETTER];                        \
    }

#define GET_CACHED_VALUE(TYPE, GETTER, DOMAIN_OBJECT, DOMAIN_GETTER) \
    -(TYPE)GETTER                                                    \
    {                                                                \
        if (!_##GETTER) {                                            \
            _##GETTER = [DOMAIN_OBJECT DOMAIN_GETTER];               \
        }                                                            \
        return _##GETTER;                                            \
    }

#define GET_LAST_VALUE(TYPE, GETTER, DOMAIN_OBJECT, DOMAIN_GETTER)                              \
    -(TYPE)GETTER                                                                               \
    {                                                                                           \
        if ([_updatedProperties containsObject:NSStringFromSelector(_cmd)] || !DOMAIN_OBJECT) { \
            return _##GETTER;                                                                   \
        } else {                                                                                \
            return [DOMAIN_OBJECT DOMAIN_GETTER];                                               \
        }                                                                                       \
    }

#define ASSIGN_IF_NOT_NIL(target, assignie) \
    if (assignie) {                         \
        target = assignie;                  \
    }

#define DLS_UPDATE_VALUE(EQUAL_FUNC, TARGET_NAME, NEW_VALUE) \
    if (!EQUAL_FUNC([self TARGET_NAME], NEW_VALUE)) {        \
        [self willChangeValueForKey:@ #TARGET_NAME];         \
    }                                                        \
    _##TARGET_NAME = NEW_VALUE;

#define DLS_IS_STRING_EQUAL(STR1, STR2) [STR1 isEqualToString:STR2]
#define DLS_IS_SCALAR_EQUAL(VAL1, VAL2) (VAL1 == VAL2)
#define DLS_IS_DICTIONARY_EQUAL(DIC1, DIC2) [DIC1 isEqualToDictionary:DIC2]
#define DLS_IS_ARRAY_EQUAL(ARR1, ARR2) NO
#define DLS_IS_OBJECT_EQUAL(OBJ1, OBJ2) [OBJ1 isEqual:OBJ2]

#define SET_UPDATE_STRING_VALUE(TARGET_NAME, NEW_VALUE) DLS_UPDATE_VALUE(DLS_IS_STRING_EQUAL, TARGET_NAME, NEW_VALUE)
#define SET_UPDATE_SCALAR_VALUE(TARGET_NAME, NEW_VALUE) DLS_UPDATE_VALUE(DLS_IS_SCALAR_EQUAL, TARGET_NAME, NEW_VALUE)
#define SET_UPDATE_DICTIONARY_VALUE(TARGET_NAME, NEW_VALUE) DLS_UPDATE_VALUE(DLS_IS_DICTIONARY_EQUAL, TARGET_NAME, NEW_VALUE)
#define SET_UPDATE_ARRAY_VALUE(TARGET_NAME, NEW_VALUE) DLS_UPDATE_VALUE(DLS_IS_ARRAY_EQUAL, TARGET_NAME, NEW_VALUE)
#define SET_UPDATE_OBJECT_VALUE(TARGET_NAME, NEW_VALUE) DLS_UPDATE_VALUE(DLS_IS_OBJECT_EQUAL, TARGET_NAME, NEW_VALUE)

#define GET_ARRAY_CACHED_VALUE_EACH_MAP(PROTOCOL, GETTER, DOMAIN_OBJECT, DOMAIN_GETTER, WRAPPER_CLASS, PURE_CLASS, EACH_MAPPER, MAPPER) \
    -(NSArray<PROTOCOL> *)GETTER                                                                                                        \
    {                                                                                                                                   \
        if (!_##GETTER) {                                                                                                               \
            dls_each_mapper_block eachMapper = EACH_MAPPER;                                                                             \
            NSMutableArray *wrappers = [NSMutableArray arrayWithCapacity:[[DOMAIN_OBJECT DOMAIN_GETTER] count]];                        \
            for (PURE_CLASS * obj in [DOMAIN_OBJECT DOMAIN_GETTER]) {                                                                   \
                WRAPPER_CLASS *wrapper = [[WRAPPER_CLASS alloc] initWithDomainObject:obj];                                              \
                if (eachMapper) {                                                                                                       \
                    wrapper = eachMapper(wrapper);                                                                                      \
                }                                                                                                                       \
                [wrappers addObject:wrapper];                                                                                           \
            }                                                                                                                           \
            _##GETTER = (NSArray<PROTOCOL> *)[NSArray arrayWithArray:wrappers];                                                         \
        }                                                                                                                               \
        dls_array_mapper_block mapper = MAPPER;                                                                                         \
        if (mapper != nil) {                                                                                                            \
            return (NSArray<PROTOCOL> *)mapper(_##GETTER);                                                                              \
        }                                                                                                                               \
        return _##GETTER;                                                                                                               \
    }

#define GET_ARRAY_CACHED_VALUE_MAP(PROTOCOL, GETTER, DOMAIN_OBJECT, DOMAIN_GETTER, WRAPPER_CLASS, PURE_CLASS, MAPPER) \
    GET_ARRAY_CACHED_VALUE_EACH_MAP(PROTOCOL, GETTER, DOMAIN_OBJECT, DOMAIN_GETTER, WRAPPER_CLASS, PURE_CLASS, nil, MAPPER)

#define GET_ARRAY_CACHED_VALUE(PROTOCOL, GETTER, DOMAIN_OBJECT, DOMAIN_GETTER, WRAPPER_CLASS, PURE_CLASS) \
    GET_ARRAY_CACHED_VALUE_MAP(PROTOCOL, GETTER, DOMAIN_OBJECT, DOMAIN_GETTER, WRAPPER_CLASS, PURE_CLASS, nil)

#endif
