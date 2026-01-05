export interface Bill {
  id: number
  value: number
  label: string
  new: boolean
  image: string
}

export function generateBill(
  id: number,
  value: number,
  label: string,
  isNew: boolean,
  imagePath: string
): Bill {
  return {
    id,
    value,
    label,
    new: isNew,
    image: imagePath
  }
}

// Example usage:
// const bill = generateBill(1, 5000, '5,000 ل.س', false, 'images/bills/old/5000.png')
