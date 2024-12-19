//
//  PhotoPickerViewModelTests.swift
//  PhotoSimulationAppMVVM
//
//  Created by user260588 on 10/23/24.
//
import XCTest
@testable import PhotoSimulationAppMVVM // Replace with your app's module name

class PhotoPickerViewModelTests: XCTestCase {
    var viewModel: PhotoPickerViewModel!

    override func setUp() {
        super.setUp()
        viewModel = PhotoPickerViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testParseText_ExtractsName() {
        let text = """
        Name: John Doe
        Amount: $123.45
        Date: 10/21/2023
        """

        let extractedData = viewModel.parseText(text)

        XCTAssertEqual(extractedData.name, "John Doe", "The name should be extracted correctly.")
    }

    func testParseText_ExtractsAmount() {
        let text = """
        Check for John Doe
        Amount: $123.45
        Date: 10/21/2023
        """

        let extractedData = viewModel.parseText(text)

        XCTAssertEqual(extractedData.amount, "$123.45", "The amount should be extracted correctly.")
    }

    func testParseText_ExtractsDate() {
        let text = """
        Check for John Doe
        Amount: $123.45
        DATE 10/21/2023
        """

        let extractedData = viewModel.parseText(text)

        XCTAssertEqual(extractedData.date, "10/21/2023", "The date should be extracted correctly.")
    }

    func testParseText_ReturnsNilForMissingFields() {
        let text = "Check for Jane Doe"

        let extractedData = viewModel.parseText(text)

        XCTAssertNil(extractedData.amount, "Amount should be nil if not present.")
        XCTAssertNil(extractedData.date, "Date should be nil if not present.")
    }
}

