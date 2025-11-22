# Ecto Schemas for Palimpsest License

This directory contains Elixir Ecto schemas for the Palimpsest License metadata infrastructure.

## Overview

[Ecto](https://hexdocs.pm/ecto/) is a database wrapper and query generator for Elixir. These schemas provide strongly-typed, validated data structures for managing Palimpsest License metadata in Phoenix/Elixir applications.

## Schemas

### license.ex
**Module:** `Palimpsest.Metadata.License`
**Table:** `palimpsest_licenses`

Core license metadata including version, governance, protection features, and jurisdiction.

**Key fields:**
- Version information (major, minor, patch, status)
- Multilingual titles and descriptions
- Governance structure (council, voting thresholds)
- Protection features (emotional lineage, quantum-proof traceability)
- Jurisdiction details (Netherlands/Scotland)

### work.ex
**Module:** `Palimpsest.Metadata.Work`
**Table:** `palimpsest_works`

Original creative works with emotional lineage and AI consent settings.

**Key features:**
- Creator information with ORCID support
- Emotional lineage tracking
- Symbolic elements with cultural origins
- Thematic integrity requirements
- AI consent management
- Accessibility features
- Quantum-proof hashing

### derivative.ex
**Module:** `Palimpsest.Metadata.Derivative`
**Table:** `palimpsest_derivatives`

Derivative works, remixes, and AI-generated content with lineage statements.

**Key features:**
- Original work references
- Comprehensive lineage statements
- Attribution tracking (direct, indirect, symbolic, environmental)
- Transformation documentation
- Reciprocity agreements
- Synthetic/AI lineage tags
- Compliance verification

### lineage.ex
**Module:** `Palimpsest.Metadata.Lineage`
**Table:** `palimpsest_lineages`

Complete chain-of-custody tracking with quantum-proof signatures.

**Key features:**
- Root work tracking
- Full transformation chain
- Quantum-proof cryptographic signatures
- Blockchain/DLT integration
- Decentralised storage (IPFS, Arweave, Filecoin)
- Merkle tree verification

### violation.ex
**Module:** `Palimpsest.Metadata.Violation`
**Table:** `palimpsest_violations`

License violations and dispute resolution tracking.

**Key features:**
- Violation type classification
- Reporter and violator information
- Evidence collection
- Panel review process (Clause 8.2)
- Resolution tracking
- Legal action documentation

## Installation

### Add to mix.exs

```elixir
defp deps do
  [
    {:ecto_sql, "~> 3.10"},
    {:postgrex, ">= 0.0.0"}  # or {:myxql, ">= 0.0.0"} for MySQL
  ]
end
```

### Configuration

```elixir
# config/config.exs
config :palimpsest, Palimpsest.Repo,
  database: "palimpsest_metadata",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :palimpsest, ecto_repos: [Palimpsest.Repo]
```

### Create Repo

```elixir
# lib/palimpsest/repo.ex
defmodule Palimpsest.Repo do
  use Ecto.Repo,
    otp_app: :palimpsest,
    adapter: Ecto.Adapters.Postgres
end
```

## Database Migrations

### Create Licenses Table

```elixir
defmodule Palimpsest.Repo.Migrations.CreateLicenses do
  use Ecto.Migration

  def change do
    create table(:palimpsest_licenses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :license_id, :string, null: false
      add :version_major, :integer, null: false
      add :version_minor, :integer, null: false
      add :version_patch, :integer, default: 0
      add :version_status, :string, null: false

      add :title_en, :string, null: false
      add :title_nl, :string
      add :description_en, :text
      add :description_nl, :text

      add :governance, :map
      add :protection, :map
      add :jurisdiction, :map

      add :canonical_uri, :string, null: false
      add :doi, :string
      add :spdx_identifier, :string

      add :created_at, :utc_datetime
      add :modified_at, :utc_datetime
      add :published_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:palimpsest_licenses, [:license_id])
    create unique_index(:palimpsest_licenses, [:canonical_uri])
    create index(:palimpsest_licenses, [:version_major, :version_minor, :version_patch])
  end
end
```

### Create Works Table

```elixir
defmodule Palimpsest.Repo.Migrations.CreateWorks do
  use Ecto.Migration

  def change do
    create table(:palimpsest_works, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :work_id, :string, null: false
      add :canonical_uri, :string, null: false
      add :license_id, :string, null: false
      add :license_version, :string

      add :title_en, :string, null: false
      add :title_nl, :string
      add :description_en, :text
      add :description_nl, :text

      add :creator, :map, null: false
      add :emotional_lineage, :map
      add :thematic_integrity, :map
      add :ai_consent, :map
      add :work_metadata, :map
      add :accessibility, :map

      add :quantum_proof_hash, :string
      add :quantum_algorithm, :string
      add :quantum_signature, :text
      add :quantum_public_key, :text

      add :status, :string, default: "draft"
      add :created_at, :utc_datetime
      add :modified_at, :utc_datetime
      add :published_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:palimpsest_works, [:work_id])
    create unique_index(:palimpsest_works, [:canonical_uri])
    create index(:palimpsest_works, [:license_id])
    create index(:palimpsest_works, [:status])
    create index(:palimpsest_works, ["(creator->>'name')"], name: :works_creator_name_index)
  end
end
```

### Create Derivatives Table

```elixir
defmodule Palimpsest.Repo.Migrations.CreateDerivatives do
  use Ecto.Migration

  def change do
    create table(:palimpsest_derivatives, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :derivative_id, :string, null: false
      add :canonical_uri, :string, null: false
      add :license_id, :string, null: false

      add :title_en, :string, null: false
      add :title_nl, :string

      add :original_work, :map, null: false
      add :derivative_creator, :map, null: false
      add :lineage_statement, :map, null: false
      add :synthetic_lineage_tag, :map
      add :compliance, :map

      add :commercial_use, :boolean, default: false
      add :status, :string, default: "draft"

      add :created_at, :utc_datetime
      add :published_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:palimpsest_derivatives, [:derivative_id])
    create unique_index(:palimpsest_derivatives, [:canonical_uri])
    create index(:palimpsest_derivatives, ["(original_work->>'uri')"], name: :derivatives_original_uri_index)
    create index(:palimpsest_derivatives, [:commercial_use])
    create index(:palimpsest_derivatives, ["(synthetic_lineage_tag->>'is_synthetic')"], name: :derivatives_synthetic_index)
  end
end
```

### Create Lineages Table

```elixir
defmodule Palimpsest.Repo.Migrations.CreateLineages do
  use Ecto.Migration

  def change do
    create table(:palimpsest_lineages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :lineage_id, :string, null: false

      add :root_work, :map, null: false
      add :chain, {:array, :map}, null: false
      add :quantum_proof, :map
      add :blockchain, :map
      add :decentralised_storage, :map

      add :verified, :boolean, default: false
      add :verification_date, :utc_datetime
      add :verifier, :string

      add :total_generations, :integer
      add :branch_count, :integer
      add :last_update, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:palimpsest_lineages, [:lineage_id])
    create index(:palimpsest_lineages, ["(root_work->>'uri')"], name: :lineages_root_uri_index)
    create index(:palimpsest_lineages, [:verified])
    create index(:palimpsest_lineages, [:total_generations])
  end
end
```

### Create Violations Table

```elixir
defmodule Palimpsest.Repo.Migrations.CreateViolations do
  use Ecto.Migration

  def change do
    create table(:palimpsest_violations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :violation_id, :string, null: false
      add :work_uri, :string, null: false
      add :work_id, :string
      add :violation_type, :string, null: false

      add :description, :text, null: false
      add :detailed_explanation, :text

      add :reported_by, :map, null: false
      add :alleged_violator, :map
      add :evidence, {:array, :map}

      add :status, :string, default: "reported"
      add :priority, :string, default: "medium"

      add :reported_at, :utc_datetime
      add :review_started_at, :utc_datetime
      add :panel_assigned_at, :utc_datetime
      add :resolved_at, :utc_datetime

      add :panel_review, :map
      add :resolution, :map
      add :legal_action, :map

      add :internal_notes, :text
      add :assigned_to, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:palimpsest_violations, [:violation_id])
    create index(:palimpsest_violations, [:work_uri])
    create index(:palimpsest_violations, [:violation_type])
    create index(:palimpsest_violations, [:status])
    create index(:palimpsest_violations, [:priority])
    create index(:palimpsest_violations, [:reported_at])
  end
end
```

## Usage Examples

### Creating a License Record

```elixir
alias Palimpsest.Metadata.License

license_attrs = %{
  license_id: "palimpsest-v0.4",
  version_major: 0,
  version_minor: 4,
  version_patch: 0,
  version_status: :in_development,
  title_en: "Palimpsest License",
  title_nl: "Palimpsest Licentie",
  canonical_uri: "https://palimpsest.license/v0.4",
  governance: %{
    council_name: "Palimpsest Stewardship Council",
    member_count: 7,
    draft_voting_threshold: "4/7",
    ratification_voting_threshold: "5/7",
    major_version_voting_threshold: "6/7"
  },
  protection: %{
    emotional_lineage: true,
    quantum_proof_traceability: true,
    symbolic_attribution: true
  },
  jurisdiction: %{
    primary_country: "Netherlands",
    enforcement_venue: "Scotland",
    governing_law: "Dutch Civil Code, Book 6"
  }
}

{:ok, license} =
  %License{}
  |> License.changeset(license_attrs)
  |> Repo.insert()
```

### Creating a Work with Emotional Lineage

```elixir
alias Palimpsest.Metadata.Work

work_attrs = %{
  work_id: "work-protest-song-001",
  canonical_uri: "https://works.example/protest-song-001",
  license_id: "palimpsest-v0.4",
  title_en: "Voices of the Displaced",
  creator: %{
    name: "Amara Okafor",
    email: "amara@example.org",
    orcid: "0000-0001-2345-6789"
  },
  emotional_lineage: %{
    context: "Created in response to forced displacement",
    themes: ["displacement", "cultural-memory", "resistance"],
    sensitivities: ["trauma", "diaspora"],
    symbolic_elements: [
      %{
        symbol: "broken-chain",
        meaning: "Breaking free from oppression",
        cultural_origin: "West African resistance movements"
      }
    ]
  },
  ai_consent: %{
    training_allowed: false,
    generation_allowed: false,
    conditions: ["No AI training permitted"]
  }
}

{:ok, work} =
  %Work{}
  |> Work.changeset(work_attrs)
  |> Repo.insert()
```

### Creating a Derivative with Lineage Statement

```elixir
alias Palimpsest.Metadata.Derivative

derivative_attrs = %{
  derivative_id: "derivative-remix-001",
  canonical_uri: "https://works.example/remix-001",
  license_id: "palimpsest-v0.4",
  title_en: "Voices Echoed: A Solidarity Remix",
  original_work: %{
    uri: "https://works.example/protest-song-001",
    creator: "Amara Okafor"
  },
  derivative_creator: %{
    name: "Chen Wei",
    email: "chen@example.org"
  },
  lineage_statement: %{
    attribution: %{
      type: :symbolic,
      content: "Honours Amara Okafor's work...",
      preserves_context: true
    },
    transformations: [
      %{
        type: :remix,
        description: "Added traditional Chinese instrumentation",
        preserves_integrity: true
      }
    ],
    reciprocity: %{
      offered: true,
      type: :percentage_share,
      details: "5% revenue sharing"
    }
  },
  commercial_use: true
}

{:ok, derivative} =
  %Derivative{}
  |> Derivative.changeset(derivative_attrs)
  |> Repo.insert()
```

### Recording a Violation

```elixir
alias Palimpsest.Metadata.Violation

violation_attrs = %{
  violation_id: "violation-report-001",
  work_uri: "https://works.example/protest-song-001",
  violation_type: :unauthorised_ai_training,
  description: "Work used for AI training without consent",
  reported_by: %{
    name: "Amara Okafor",
    email: "amara@example.org",
    relationship: :creator
  },
  evidence: [
    %{
      type: :url,
      content: "https://ai-corp.example/training-data"
    }
  ]
}

{:ok, violation} =
  %Violation{}
  |> Violation.changeset(violation_attrs)
  |> Repo.insert()
```

### Querying Works by AI Consent

```elixir
import Ecto.Query

# Find works that allow AI training
query = from w in Work,
  where: fragment("(?->>'training_allowed')::boolean = true", w.ai_consent),
  select: w

Repo.all(query)

# Find works with high sensitivity
query = from w in Work,
  where: fragment("? @> ?", w.emotional_lineage,
    ~s({"sensitivities": ["trauma"]})),
  select: w

Repo.all(query)
```

### Tracking Lineage Chains

```elixir
alias Palimpsest.Metadata.Lineage

# Create lineage chain
lineage_attrs = %{
  lineage_id: "lineage-chain-001",
  root_work: %{
    uri: "https://works.example/original",
    creator: "Original Creator"
  },
  chain: [
    %{
      uri: "https://works.example/original",
      creator: "Original Creator",
      timestamp: ~U[2024-01-01 00:00:00Z],
      transformation_type: :original,
      generation_number: 0
    },
    %{
      uri: "https://works.example/remix",
      creator: "Remixer",
      timestamp: ~U[2024-06-01 00:00:00Z],
      transformation_type: :remix,
      generation_number: 1
    }
  ],
  quantum_proof: %{
    algorithm: :"SPHINCS+",
    signature: "quantum-resistant-signature...",
    public_key: "public-key..."
  }
}

{:ok, lineage} =
  %Lineage{}
  |> Lineage.changeset(lineage_attrs)
  |> Repo.insert()

# Get all creators in chain
Lineage.all_creators(lineage)
# => ["Original Creator", "Remixer"]
```

## Validation

All schemas include comprehensive validation:

- **Required fields** - Ensures critical data is present
- **Format validation** - URIs, emails, ORCIDs, etc.
- **Business logic** - E.g., commercial use requires reciprocity
- **Consistency checks** - E.g., AI-generated works need synthetic tags
- **Enum validation** - Restricted value sets for status fields

## Testing

```elixir
# test/palimpsest/metadata/work_test.exs
defmodule Palimpsest.Metadata.WorkTest do
  use Palimpsest.DataCase
  alias Palimpsest.Metadata.Work

  describe "changeset/2" do
    test "valid work attributes" do
      attrs = %{
        work_id: "work-test-001",
        canonical_uri: "https://example.org/work",
        license_id: "palimpsest-v0.4",
        title_en: "Test Work",
        creator: %{name: "Test Creator"}
      }

      changeset = Work.changeset(%Work{}, attrs)
      assert changeset.valid?
    end

    test "requires emotional lineage context" do
      attrs = %{
        emotional_lineage: %{themes: ["test"]}
      }

      changeset = Work.changeset(%Work{}, attrs)
      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).emotional_lineage
    end
  end
end
```

## Performance Considerations

### Indexing

Key indexes for performance:
- Work URIs and creator names
- Derivative original work references
- Violation status and type
- Lineage root work URIs

### JSONB Queries

For PostgreSQL, consider using JSONB columns for embedded data:

```elixir
# In migration
add :emotional_lineage, :map  # Stores as jsonb in PostgreSQL

# Efficient querying
from w in Work,
  where: fragment("? @> ?", w.emotional_lineage,
    ~s({"sensitivities": ["trauma"]}))
```

### Indexes on JSONB Fields

```elixir
create index(:palimpsest_works, ["(emotional_lineage->>'context')"])
create index(:palimpsest_works, ["emotional_lineage"], using: :gin)
```

## Integration with Phoenix

### Context Module

```elixir
defmodule Palimpsest.Metadata do
  import Ecto.Query
  alias Palimpsest.Repo
  alias Palimpsest.Metadata.{Work, Derivative, Violation}

  def create_work(attrs) do
    %Work{}
    |> Work.changeset(attrs)
    |> Repo.insert()
  end

  def list_works_by_creator(creator_name) do
    from(w in Work,
      where: fragment("?->>'name' = ?", w.creator, ^creator_name)
    )
    |> Repo.all()
  end

  def report_violation(attrs) do
    %Violation{}
    |> Violation.changeset(attrs)
    |> Repo.insert()
  end
end
```

## Licence

These Ecto schemas are licensed under the Palimpsest License v0.4.

## Further Reading

- [Ecto Documentation](https://hexdocs.pm/ecto/)
- [Ecto Schema Documentation](https://hexdocs.pm/ecto/Ecto.Schema.html)
- [Ecto Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)
- [Phoenix Framework](https://www.phoenixframework.org/)
