{-# LANGUAGE OverloadedStrings #-}

module Palimpsest.Validator.MetadataSpec (metadataSpec) where

import Test.Hspec
import Palimpsest.Validator.Metadata

metadataSpec :: Spec
metadataSpec = describe "Metadata Validator" $ do
  describe "File type detection" $ do
    it "detects JSON-LD files" $ do
      pending "File type detection tests to be implemented"

  describe "JSON-LD validation" $ do
    it "validates valid JSON-LD" $ do
      pending "JSON-LD validation tests to be implemented"

  describe "XML validation" $ do
    it "validates valid XML lineage tags" $ do
      pending "XML validation tests to be implemented"
