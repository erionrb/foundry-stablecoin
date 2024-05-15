# Foundry Stablecoin

## Introduction

This is a system designed to maintain a stablecoin with a 1 token = $1 peg. It operates with the following key properties:

- Exogenous Collateral
- Dollar Pegged
- Algorithmically Stable

It is akin to DAI, but without governance, fees, and solely backed by WETH and WBTC.

## Overview

The DSCEngine ensures that the stablecoin, termed DSC, remains overcollateralized at all times. This means that the total value of collateral should always exceed the value of all DSC in circulation.

## Functionality

This contract serves as the core of the DSC System, handling various functionalities including:

- Mining and redeeming DSCm
- Depositing and withdrawing collateral

## Acknowledgement

This contract draws inspiration from the MakerDAO DSS (DAI) system but operates with a distinct approach and set of features.

## Notice

This repo is based on Patrick Collins Solidity Course.
https://www.youtube.com/watch?v=wUjYK5gwNZs&t=4981s
