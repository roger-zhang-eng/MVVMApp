# MVVMApp
iOS application that demostrates how to use ReactiveSwift, ReactiveCocoa and the MVVM pattern to develop iOS Applications

### Structure

The project is divided in layers

1. MVVMModels: responsible for fetching data from the API and storing them locally.
2. MVVMViewModels: responsible for coordinating the various MVVMModels functions and the UI.
3. MVVMViews: some views that are directly coordinated by the MVVMViewModels.

Each layer only has access to the layer before it (e.g MVVMViewModels only has access to MVVMModels and MVVMViews only has access to MVVMViewModels)

### SOLID

The project tries to be as SOLID as possible. It implements the following:

1. Single Responsibility: can be found in MVVMModels a lot (e.g PostRepository, is only responsible for Post related stuff)
2. Open/Closed: mostly found in the various repositories in MVVMModels (closed)
3. Liskov substitution: look at persistence
4. Interface segregation: all over the place, mostly in the MVVMModels and MVVMViewModels (various providers)
5. Dependency inversion: MVVMViewModels are dependent only in the abstract protocols (providers) defined in MVVMModels and not in their concrete implementations.

### Dependency Injection

The project uses SwiftInject for depency injection. Everything is handled in the AppDelegate.swift

### DRY

By using extensions the project is able to be as DRY as possible.

### Persistence

Internally, MVVMModels use CoreData to handle persistence but that does not concern the user since no CoreData entity is made publicly accessible to users. 
Instead simple structs are made available to users meaning that we could move from CoreData to e.g Realm without breaking anything except withing the MVVMModels codebase.
