class ReceiptOcrService
  def initialize(image_path)
    @image_path = image_path
  end

  def process
    # Use Tesseract to extract text from the image
    text = Tesseract::Engine.new{ |e| e.language = :eng }.text_for(@image_path)

    # Parse the text to find amount and reference number
    amount = extract_amount(text)
    reference_number = extract_reference_number(text)

    { amount: amount, reference_number: reference_number }
  end

  private

  def extract_amount(text)
    # Logic to extract amount from the text
    # Example regex to find amounts
    if match = text.match(/[\d,]+\.\d{2}/) # Adjust regex as per your receipt format
      match[0].to_f
    end
  end

  def extract_reference_number(text)
    # Logic to extract reference number from the text
    # Example logic depending on how reference numbers are formatted
    if match = text.match(/Ref:\s*(\w+)/) # Adjust regex as per your receipt format
      match[1]
    end
  end
end
