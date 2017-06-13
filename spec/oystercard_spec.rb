require './lib/oystercard.rb'
describe Oystercard do


	# it { is_expected.to respond_to(:deduct).with(1).argument }

	it { is_expected.to respond_to(:top_up).with(1).argument }

	let(:card) {described_class.new}

	it "expects the card to have a balance of 0 when initialized" do
		expect(card.balance).to eq 0
	end

	describe "#top_up" do
		it "increases the card balance by a specified amount" do
			expect{ subject.top_up 10 }.to change{ subject.balance }.by +10
		end
		context "If top up makes balance exceed limit of £90"
		it "raises an error" do
			card.top_up(Oystercard::CARD_LIMIT)
			expect{card.top_up(1)}.to raise_error("Can't top up above £#{Oystercard::CARD_LIMIT}")
		end
	end

	# describe "#deduct" do
	# 	it "deducts some amount from the card balance" do
	# 		expect{ subject.send(:deduct, 10)}.to change{ subject.balance }.by -10
	# 	end
	# end

	describe "#touch_in" do
		context "Where there is greater than £1 credit on card" do
		it "can touch in and change status to in use" do
			subject.top_up(10)
			subject.touch_in
			expect(subject).to be_in_journey
		end
	end
		context "when card has less than £1 credit" do
			it "raises an error" do
			expect{subject.touch_in}.to raise_error("Not enough credit - please top up!")
		end
	end
end

	describe "#in_journey?" do
		it "tells whether a card is in use" do
			subject.top_up(10)
			subject.touch_in
			expect(subject).to be_in_journey
		end
	end

	describe "#touch_out" do
		it "can touch out and change status to not in use" do
			subject.top_up(10)
			subject.touch_in
			subject.touch_out
			expect(subject).not_to be_in_journey
		end
		it "deducts the right amount from the balance upon touching out " do
			subject.top_up(10)
			subject.touch_in
			expect{ subject.touch_out }.to change{ subject.balance }.by -Oystercard::MINIMUM_CHARGE
		end
	end
end
