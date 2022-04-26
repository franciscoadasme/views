# Views

A collection of views and wrappers of collection types such as `Array`
and `Hash`.

A view is a read-only version of the corresponding type, e.g,
`ArrayView` gives access to an `Array`.

A wrapper is like a view, but the methods returning the same type
instead will return a wrapped value, e.g., `ArrayWrapper#select` method
will return an `ArrayWrapper` instead of an `Array`. There are both
read-only and mutable variants of each wrapper, e.g., `ArrayWrapper` and
`ArrayWrapper::Mutable`.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     views:
       github: franciscoadasme/views
   ```

2. Run `shards install`

## Usage

```crystal
require "views"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/franciscoadasme/views/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Francisco Adasme](https://github.com/franciscoadasme) - creator and maintainer
