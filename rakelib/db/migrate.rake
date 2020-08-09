# frozen_string_literal: true

namespace :db do
  require 'sequel/core'

  desc 'Run database migrations'
  task :migrate, %i[version] => :settings do |_t, args|
    Sequel.extension :migration

    Sequel.connect(Settings.db.to_hash) do |db|
      migrations = File.expand_path('../../db/migrations', __dir__)
      version = args.version.to_i if args.version

      Sequel::Migrator.run(db, migrations, target: version)
    end

    Rake::Task['db:schema:dump'].execute
  end

  desc 'Run database seeds'
  task seed: :environment do
    require 'sequel/extensions/seed'

    Sequel.extension :seed

    Sequel.connect(Settings.db.to_hash) do |db|
      seeds_dir = File.expand_path('../../db/seeds', __dir__)
      Sequel::Seeder.apply(db, seeds_dir)
    end
  end

  namespace :schema do
    desc 'Generate database schema'
    task dump: :settings do
      Sequel.connect(Settings.db.to_hash) do |db|
        dump_file = File.expand_path('../../db/schema.rb', __dir__)
        db.extension(:schema_dumper)

        File.write(dump_file, db.dump_schema_migration)
      end
    end
  end
end
