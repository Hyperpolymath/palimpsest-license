{-# LANGUAGE OverloadedStrings #-}

module Palimpsest.Validator.LicenseSpec (licenseSpec) where

import Test.Hspec
import Data.Text (Text)
import qualified Data.Text as T
import Palimpsest.Validator.License

licenseSpec :: Spec
licenseSpec = describe "License Validator" $ do
  describe "Clause extraction" $ do
    it "extracts version from text" $ do
      let text = "# Palimpsest License v0.3"
      extractVersion text `shouldBe` "0.3"

    it "detects license header" $ do
      let text = "# Palimpsest License v0.3\n\nContent..."
      hasLicenseHeader text `shouldBe` True

    it "detects English language" $ do
      let text = "Governing Law: Netherlands"
      detectLanguage text `shouldBe` Just English

    it "detects Dutch language" $ do
      let text = "Toepasselijk Recht: Nederland"
      detectLanguage text `shouldBe` Just Dutch

  describe "Clause number parsing" $ do
    it "parses simple clause numbers" $ do
      parseClauseNumber "1" `shouldBe` Just 1
      parseClauseNumber "42" `shouldBe` Just 42

    it "handles invalid input" $ do
      parseClauseNumber "abc" `shouldBe` Nothing
      parseClauseNumber "" `shouldBe` Nothing
